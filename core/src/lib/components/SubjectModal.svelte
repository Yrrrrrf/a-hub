<!-- src/lib/components/SubjectModal.svelte -->
<script lang="ts">
    import { Clock, MapPin, X, CalendarCheck, BookOpen, GraduationCap } from 'phosphor-svelte';
    import type { Subject } from '$lib/stores/schedule.svelte';
    import { goto } from '$app/navigation';
    
    // Props with runes
    let { subject, days = [], onClose } = $props<{
        subject: Subject;
        days?: string[];
        onClose?: () => void;
    }>();

    // Local state
    let isOpen = $state(true);

    // Helper function for time formatting
    function getTimeString(hour: number) {
        return `${hour.toString().padStart(2, '0')}:00`;
    }

    // Handle closing
    function handleClose() {
        isOpen = false;
        if (onClose) onClose();
    }

    // Handle keyboard events
    function handleKeydown(event: KeyboardEvent) {
        if (event.key === 'Escape') {
            handleClose();
        }
    }

    function handleShowDetails() {
        if (subject.pdfLink) {
            // Open PDF in new tab
            window.open(subject.pdfLink, '_blank');
        }
    }
</script>

<svelte:window on:keydown={handleKeydown}/>

{#if isOpen}
    <div class="modal modal-open" role="dialog" aria-modal="true">
        <!-- Backdrop -->
        <button 
            class="modal-backdrop bg-black/60 backdrop-blur-sm"
            onclick={handleClose}
            aria-label="Close modal"
        ></button>

        <!-- Modal Content -->
        <div class="modal-box max-w-2xl overflow-hidden p-0">
            <!-- Header with colored background -->
            <div 
                class="relative p-6 text-white"
                style="background-color: {subject.color}"
            >
                <!-- Close button -->
                <button 
                    class="btn btn-circle btn-ghost btn-sm absolute right-2 top-2 text-white/80 hover:text-white"
                    onclick={handleClose}
                >
                    <X weight="bold" class="w-4 h-4" />
                </button>

                <!-- Subject icon and title -->
                <div class="flex items-start gap-4">
                    <div class="w-12 h-12 rounded-lg bg-white/10 flex items-center justify-center backdrop-blur-sm">
                        <subject.icon weight="duotone" class="w-7 h-7" />
                    </div>
                    <div>
                        <h3 class="text-2xl font-bold">{subject.name}</h3>
                        <p class="text-white/80 flex items-center gap-2 mt-1">
                            <BookOpen class="w-4 h-4" />
                            Course ID: {subject.id}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Body content -->
            <div class="p-6 space-y-6">
                <!-- Time and Location Section -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Schedule Info -->
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="text-sm font-semibold flex items-center gap-2 mb-2">
                                <Clock class="text-primary w-4 h-4" />
                                Schedule
                            </h4>
                            <div class="space-y-2">
                                <div class="flex items-center gap-2">
                                    <CalendarCheck class="w-4 h-4 opacity-70" />
                                    <span>{days[subject.day - 1] || `Day ${subject.day}`}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <Clock class="w-4 h-4 opacity-70" />
                                    <span>{getTimeString(subject.startHour)} - {getTimeString(subject.startHour + subject.duration)}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Location Info -->
                    {#if subject.room}
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="text-sm font-semibold flex items-center gap-2 mb-2">
                                    <MapPin class="text-primary w-4 h-4" />
                                    Location
                                </h4>
                                <div class="text-lg font-medium">Room {subject.room}</div>
                                <div class="text-sm opacity-70">Main Campus</div>
                            </div>
                        </div>
                    {/if}
                </div>

                <!-- Professor Section -->
                {#if subject.professor}
                    <div class="border-t pt-6">
                        <h4 class="text-sm font-semibold flex items-center gap-2 mb-4">
                            <GraduationCap class="text-primary w-4 h-4" />
                            Course Instructor
                        </h4>
                        <div class="flex items-center gap-4">
                            <div class="avatar placeholder">
                                <div class="bg-neutral text-neutral-content rounded-full w-16">
                                    <span class="text-xl">{subject.professor.split(' ').map((n: string) => n[0]).join('')}</span>
                                </div>
                            </div>
                            <div>
                                <div class="font-medium text-lg">{subject.professor}</div>
                                <div class="text-sm opacity-70">Professor</div>
                            </div>
                        </div>
                    </div>
                {/if}

                <!-- Actions -->
                <div class="flex justify-end gap-2 border-t pt-6">
                    <button class="btn btn-primary"
                        onclick={handleShowDetails}
                    >
                        Show Details
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}