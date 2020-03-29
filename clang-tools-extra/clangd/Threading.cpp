#include "Threading.h"
#include "Trace.h"
#include "clang/Basic/Stack.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/Threading.h"
#include <atomic>
#include <thread>
#ifdef __USE_POSIX
#include <pthread.h>
#elif defined(__APPLE__)
#include <sys/resource.h>
#elif defined (_WIN32)
#include <windows.h>
#endif

namespace clang {
namespace clangd {

void Notification::notify() {
  {
    std::lock_guard<std::mutex> Lock(Mu);
    Notified = true;
    // Broadcast with the lock held. This ensures that it's safe to destroy
    // a Notification after wait() returns, even from another thread.
    CV.notify_all();
  }
}

void Notification::wait() const {
  std::unique_lock<std::mutex> Lock(Mu);
  CV.wait(Lock, [this] { return Notified; });
}

Semaphore::Semaphore(std::size_t MaxLocks) : FreeSlots(MaxLocks) {}

bool Semaphore::try_lock() {
  std::unique_lock<std::mutex> Lock(Mutex);
  if (FreeSlots > 0) {
    --FreeSlots;
    return true;
  }
  return false;
}

void Semaphore::lock() {
  trace::Span Span("WaitForFreeSemaphoreSlot");
  // trace::Span can also acquire locks in ctor and dtor, we make sure it
  // happens when Semaphore's own lock is not held.
  {
    std::unique_lock<std::mutex> Lock(Mutex);
    SlotsChanged.wait(Lock, [&]() { return FreeSlots > 0; });
    --FreeSlots;
  }
}

void Semaphore::unlock() {
  std::unique_lock<std::mutex> Lock(Mutex);
  ++FreeSlots;
  Lock.unlock();

  SlotsChanged.notify_one();
}

AsyncTaskRunner::~AsyncTaskRunner() { wait(); }

bool AsyncTaskRunner::wait(Deadline D) const {
  std::unique_lock<std::mutex> Lock(Mutex);
  return clangd::wait(Lock, TasksReachedZero, D,
                      [&] { return InFlightTasks == 0; });
}

void AsyncTaskRunner::runAsync(const llvm::Twine &Name,
                               llvm::unique_function<void()> Action) {
  {
    std::lock_guard<std::mutex> Lock(Mutex);
    ++InFlightTasks;
  }

  auto CleanupTask = llvm::make_scope_exit([this]() {
    std::lock_guard<std::mutex> Lock(Mutex);
    int NewTasksCnt = --InFlightTasks;
    if (NewTasksCnt == 0) {
      // Note: we can't unlock here because we don't want the object to be
      // destroyed before we notify.
      TasksReachedZero.notify_one();
    }
  });

  auto Task = [Name = Name.str(), Action = std::move(Action),
               Cleanup = std::move(CleanupTask)]() mutable {
    llvm::set_thread_name(Name);
    Action();
    // Make sure function stored by ThreadFunc is destroyed before Cleanup runs.
    Action = nullptr;
  };

  // Ensure our worker threads have big enough stacks to run clang.
  llvm::llvm_execute_on_thread_async(std::move(Task), clang::DesiredStackSize);
}

Deadline timeoutSeconds(llvm::Optional<double> Seconds) {
  using namespace std::chrono;
  if (!Seconds)
    return Deadline::infinity();
  return steady_clock::now() +
         duration_cast<steady_clock::duration>(duration<double>(*Seconds));
}

void wait(std::unique_lock<std::mutex> &Lock, std::condition_variable &CV,
          Deadline D) {
  if (D == Deadline::zero())
    return;
  if (D == Deadline::infinity())
    return CV.wait(Lock);
  CV.wait_until(Lock, D.time());
}

} // namespace clangd
} // namespace clang
