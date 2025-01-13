<!-- src/lib/components/WeeklySchedule.svelte -->
<script lang="ts">
    import { fade } from 'svelte/transition';
    import { Clock, MapPin, User } from 'phosphor-svelte';
    import { scheduleStore, type Subject } from '$lib/stores/schedule.svelte';


    // Add new prop for preview subject
    let { previewSubject } = $props<{
        previewSubject?: Subject | null;
    }>();

    // Derived values using runes
    let subjects = $derived(scheduleStore.subjects);
    let days = $derived(scheduleStore.days);
    let hours = $derived(scheduleStore.hours);

    // Local state
    let hoveredSubject = $state<Subject | null>(null);
    let selectedSubject = $state<Subject | null>(null);

    function getTimeString(hour: number) {
        return `${hour.toString().padStart(2, '0')}:00`;
    }

    function handleSubjectHover(subject: Subject | null) {
        hoveredSubject = subject;
    }

    function handleSubjectClick(subject: Subject) {
        selectedSubject = subject;
    }
</script>

<div class="card bg-base-100 shadow-xl">
    <div class="card-body p-2">
        <!-- Calendar Grid -->
        <div class="overflow-x-auto">
            <div class="schedule-grid min-w-[800px]">
                <!-- Time Column Header -->
                <div class="time-header">Time</div>
                
                <!-- Day Headers -->
                {#each days as day}
                    <div class="day-header">{day}</div>
                {/each}

                <!-- Time Slots -->
                {#each hours as hour}
                    <!-- Hour Label -->
                    <div class="hour-cell">
                        {getTimeString(hour)} - {getTimeString(hour + 1)}
                    </div>

                    <!-- Day Cells -->
                    {#each days as _, dayIndex}
                        <div class="schedule-cell relative min-h-[4rem]">
                            {#each subjects.filter(subject => 
                                subject.day === dayIndex + 1 && 
                                subject.startHour <= hour && 
                                hour < subject.startHour + subject.duration
                            ) as subject (subject.id)}
                                <button
                                    class="subject-block absolute inset-x-0 m-px rounded-lg transition-all duration-200 hover:scale-[1.02] hover:shadow-lg cursor-pointer overflow-hidden"
                                    style="
                                        top: {(subject.startHour - hour) * 100}%;
                                        height: {subject.duration * 100}%;
                                        background-color: {subject.color};
                                    "
                                    onclick={() => handleSubjectClick(subject)}
                                    onmouseenter={() => handleSubjectHover(subject)}
                                    onmouseleave={() => handleSubjectHover(null)}
                                >
                                    <div class="p-2 text-white h-full flex flex-col justify-between">
                                        <div class="flex items-center gap-2 font-medium">
                                            <subject.icon weight="duotone" class="w-4 h-4" />
                                            <span class="truncate">{subject.name}</span>
                                        </div>
                                        <div class="text-xs opacity-90">
                                            {getTimeString(subject.startHour)} - {getTimeString(subject.startHour + subject.duration)}
                                        </div>
                                    </div>
                                </button>
                            {/each}
                        </div>
                    {/each}
                {/each}
            </div>
        </div>
    </div>
</div>

<!-- Hover Details -->
{#if hoveredSubject && !selectedSubject}
    <div 
        class="fixed bottom-4 right-4 card bg-base-100 shadow-xl w-72"
        transition:fade
    >
        <div class="card-body">
            <h3 class="card-title flex items-center gap-2">
                <hoveredSubject.icon weight="duotone" class="text-primary" />
                {hoveredSubject.name}
            </h3>
            <div class="space-y-2 text-sm">
                <div class="flex items-center gap-2">
                    <Clock class="text-primary" />
                    <span>
                        {days[hoveredSubject.day - 1]}, 
                        {getTimeString(hoveredSubject.startHour)} - 
                        {getTimeString(hoveredSubject.startHour + hoveredSubject.duration)}
                    </span>
                </div>
                {#if hoveredSubject.room}
                    <div class="flex items-center gap-2">
                        <MapPin class="text-primary" />
                        <span>Room {hoveredSubject.room}</span>
                    </div>
                {/if}
                {#if hoveredSubject.professor}
                    <div class="flex items-center gap-2">
                        <User class="text-primary" />
                        <span>{hoveredSubject.professor}</span>
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/if}

<!-- Selected Subject Modal -->
{#if selectedSubject}
    <div class="modal modal-open">
        <div class="modal-box">
            <h3 class="font-bold text-lg flex items-center gap-2">
                <selectedSubject.icon weight="duotone" class="text-primary" />
                {selectedSubject.name}
            </h3>
            <div class="py-4 space-y-4">
                <div class="flex items-center gap-3">
                    <Clock class="text-primary w-5 h-5" />
                    <div>
                        <div class="font-medium">{days[selectedSubject.day - 1]}</div>
                        <div class="text-sm opacity-70">
                            {getTimeString(selectedSubject.startHour)} - 
                            {getTimeString(selectedSubject.startHour + selectedSubject.duration)}
                        </div>
                    </div>
                </div>
                {#if selectedSubject.room}
                    <div class="flex items-center gap-3">
                        <MapPin class="text-primary w-5 h-5" />
                        <div>
                            <div class="font-medium">Location</div>
                            <div class="text-sm opacity-70">Room {selectedSubject.room}</div>
                        </div>
                    </div>
                {/if}
                {#if selectedSubject.professor}
                    <div class="flex items-center gap-3">
                        <User class="text-primary w-5 h-5" />
                        <div>
                            <div class="font-medium">Professor</div>
                            <div class="text-sm opacity-70">{selectedSubject.professor}</div>
                        </div>
                    </div>
                {/if}
            </div>
            <div class="modal-action">
                <button class="btn" onclick={() => selectedSubject = null}>Close</button>
            </div>
        </div>
        <button class="modal-backdrop" onclick={() => selectedSubject = null}>
            <span class="sr-only">Close</span>
        </button>
    </div>
{/if}

<style>
    .schedule-grid {
        display: grid;
        grid-template-columns: auto repeat(5, 1fr);
        gap: 1px;
        background-color: hsl(var(--b3));
        border-radius: 0.5rem;
        overflow: hidden;
    }

    .time-header, .day-header {
        background-color: hsl(var(--b2));
        padding: 0.75rem;
        text-align: center;
        font-weight: 600;
    }

    .hour-cell {
        background-color: hsl(var(--b1));
        padding: 0.5rem;
        text-align: center;
        font-size: 0.75rem;
        color: hsl(var(--bc)/0.7);
    }

    .schedule-cell {
        background-color: hsl(var(--b1));
        border: 1px solid hsl(var(--b3));
    }

    .subject-block {
        position: absolute;
        left: 0;
        right: 0;
    }

    /* Hide scrollbars but allow scrolling */
    ::-webkit-scrollbar {
        display: none;
    }
    * {
        -ms-overflow-style: none;
        scrollbar-width: none;
    }
</style>