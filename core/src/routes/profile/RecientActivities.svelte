<script lang="ts">
    import { Calendar, Clock, FileText, Books, Bell, CaretRight } from 'phosphor-svelte';
    import { okl } from '$lib/stores/profile.svelte';

    // Get data from store using derived values
    let activities = $derived(okl.recentActivities);
    let library = $derived(okl.libraryItems);
    let deadlines = $derived(okl.upcomingDeadlines);
</script>

<!-- Recent Activities Panel -->
<div class="card bg-base-100 shadow-xl overflow-hidden hover:shadow-2xl transition-all duration-300">
    <div class="card-body p-6">
        <h2 class="card-title flex items-center gap-2 mb-4">
            <Bell weight="duotone" class="text-primary w-6 h-6" />
            Recent Activities
            <span class="badge badge-primary badge-sm">{activities.length}</span>
        </h2>

        <div class="space-y-3">
            {#each activities as activity}
                <div class="group relative bg-base-200 rounded-xl p-4 hover:bg-base-300 transition-all duration-200 hover:-translate-y-0.5">
                    <div class="flex items-center gap-4">
                        <div class="shrink-0">
                            {#if activity.type === 'submission'}
                                <div class="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
                                    <FileText weight="duotone" class="text-primary w-6 h-6" />
                                </div>
                            {:else if activity.type === 'attendance'}
                                <div class="w-10 h-10 rounded-lg bg-secondary/10 flex items-center justify-center">
                                    <Calendar weight="duotone" class="text-secondary w-6 h-6" />
                                </div>
                            {:else}
                                <div class="w-10 h-10 rounded-lg bg-accent/10 flex items-center justify-center">
                                    <Books weight="duotone" class="text-accent w-6 h-6" />
                                </div>
                            {/if}
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="font-semibold line-clamp-1">{activity.action}</p>
                            <div class="flex items-center gap-2 text-sm opacity-70 mt-1">
                                <Clock class="w-4 h-4" />
                                <span>{activity.date}</span>
                            </div>
                        </div>
                        <div class="shrink-0 flex items-center gap-2">
                            <span class="badge badge-ghost">{activity.status}</span>
                            <CaretRight class="w-4 h-4 opacity-0 group-hover:opacity-70 transition-all" />
                        </div>
                    </div>
                </div>
            {/each}
        </div>
    </div>
</div>

<!-- Secondary Cards Grid -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
    <!-- Deadlines Card -->
    <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300">
        <div class="card-body p-6">
            <h2 class="card-title flex items-center gap-2 mb-4">
                <Clock weight="duotone" class="text-primary w-6 h-6" />
                Upcoming Deadlines
                <span class="badge badge-sm badge-primary">{deadlines.length}</span>
            </h2>
            <div class="space-y-3">
                {#each deadlines as deadline}
                    <div class="group p-4 bg-base-200 rounded-xl hover:bg-base-300 transition-all duration-200 hover:-translate-y-0.5">
                        <div class="flex justify-between items-start">
                            <div>
                                <h3 class="font-semibold line-clamp-1">{deadline.task}</h3>
                                <p class="text-sm opacity-70 mt-1">{deadline.course}</p>
                            </div>
                            <div class="badge badge-primary">{deadline.dueDate}</div>
                        </div>
                        <div class="h-1 w-full bg-base-300 rounded-full mt-3 overflow-hidden">
                            <div class="h-full bg-primary rounded-full" style="width: 75%"></div>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </div>

    <!-- Library Card -->
    <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300">
        <div class="card-body p-6">
            <h2 class="card-title flex items-center gap-2 mb-4">
                <Books weight="duotone" class="text-primary w-6 h-6" />
                Library Items
                <span class="badge badge-sm badge-primary">{library.length}</span>
            </h2>
            <div class="space-y-3">
                {#each library as item}
                    <div class="group bg-base-200 rounded-xl p-4 hover:bg-base-300 transition-all duration-200 hover:-translate-y-0.5">
                        <div class="flex items-start justify-between gap-4">
                            <div class="flex-1 min-w-0">
                                <h3 class="font-semibold line-clamp-1">{item.title}</h3>
                                <div class="flex items-center gap-2 text-sm opacity-70 mt-1">
                                    <Clock class="w-4 h-4" />
                                    <span>Due: {item.dueDate}</span>
                                </div>
                            </div>
                            <div class="shrink-0">
                                <span class="badge badge-ghost">{item.status}</span>
                            </div>
                        </div>
                        <div class="mt-3 flex items-center justify-end gap-2 text-sm opacity-0 group-hover:opacity-100 transition-all">
                            <button class="btn btn-ghost btn-xs gap-1">
                                Renew
                                <Clock class="w-3 h-3" />
                            </button>
                            <button class="btn btn-ghost btn-xs gap-1">
                                Details
                                <CaretRight class="w-3 h-3" />
                            </button>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </div>
</div>