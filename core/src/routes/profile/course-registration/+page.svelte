<script lang="ts">
    import WeeklySchedule from "../schedule/WeeklySchedule.svelte";
    import { scheduleStore } from '$lib/stores/schedule.svelte';
    import type { Subject } from '$lib/stores/schedule.svelte';

    import { Database, Network, Robot, Cpu } from 'phosphor-svelte';

    // Available courses to test adding/removing
    const availableCourses: Subject[] = [
        {
            id: 'db-101',
            name: 'Database Systems',
            day: 1,
            startHour: 13,
            duration: 2,
            color: 'hsl(199, 89%, 48%)', // Blue
            icon: Database,
            professor: 'Dr. Anderson',
            room: 'CS401'
        },
        {
            id: 'algo-201',
            name: 'Algorithms',
            day: 2,
            startHour: 9,
            duration: 2,
            color: 'hsl(280, 85%, 65%)', // Purple
            icon: Database,
            professor: 'Dr. Zhang',
            room: 'CS302'
        },
        {
            id: 'net-301',
            name: 'Computer Networks',
            day: 3,
            startHour: 11,
            duration: 2,
            color: 'hsl(150, 75%, 40%)', // Green
            icon: Network,
            professor: 'Dr. Patel',
            room: 'CS203'
        },
        {
            id: 'ai-401',
            name: 'Artificial Intelligence',
            day: 4,
            startHour: 14,
            duration: 2,
            color: 'hsl(345, 85%, 55%)', // Red
            icon: Robot,
            professor: 'Dr. Lee',
            room: 'CS405'
        },
        {
            id: 'arch-201',
            name: 'Computer Architecture',
            day: 5,
            startHour: 10,
            duration: 2,
            color: 'hsl(32, 95%, 44%)', // Orange
            icon: Cpu,
            professor: 'Dr. Martinez',
            room: 'CS204'
        }
    ];

    // Helper function to check if course can be added
    function canAddCourse(newCourse: Subject, existingCourses: Subject[]): boolean {
        return !existingCourses.some(course => 
            course.day === newCourse.day && (
                (newCourse.startHour >= course.startHour && 
                newCourse.startHour < course.startHour + course.duration) ||
                (newCourse.startHour + newCourse.duration > course.startHour && 
                newCourse.startHour < course.startHour + course.duration)
            )
        );
    }


    // Local state using runes
    let error = $state<string | null>(null);
    let selectedCourses = $derived(scheduleStore.subjects);

    // Handle adding a course
    function handleAddCourse(course: Subject) {
        // Check for time conflicts
        if (!canAddCourse(course, selectedCourses)) {
            error = "Time conflict detected! Cannot add this course.";
            setTimeout(() => error = null, 3000);
            return;
        }

        try {
            scheduleStore.addSubject(course);
            error = null;
        } catch (e) {
            error = e instanceof Error ? e.message : "Failed to add course";
        }
    }

    // Handle removing a course
    function handleRemoveCourse(courseId: string) {
        try {
            scheduleStore.removeSubject(courseId);
            error = null;
        } catch (e) {
            error = e instanceof Error ? e.message : "Failed to remove course";
        }
    }
</script>

<div class="container mx-auto px-4 py-8 space-y-8">
    <!-- Header -->
    <div class="text-center space-y-4">
        <h1 class="text-4xl font-bold">Course Registration</h1>
        <p class="text-xl opacity-80">Select courses to add to your schedule</p>
    </div>

    <!-- Error Alert -->
    {#if error}
        <div class="alert alert-error">
            <span>{error}</span>
        </div>
    {/if}

    <!-- Available Courses -->
    <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
            <h2 class="card-title">Available Courses</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {#each availableCourses as course}
                    <div class="card bg-base-200 shadow-lg hover:shadow-xl transition-all">
                        <div class="card-body">
                            <div class="flex items-center gap-3 mb-2">
                                <course.icon weight="duotone" class="w-8 h-8" style="color: {course.color}" />
                                <div>
                                    <h3 class="font-bold">{course.name}</h3>
                                    <p class="text-sm opacity-70">{course.professor}</p>
                                </div>
                            </div>
                            <div class="text-sm space-y-1">
                                <p>Room: {course.room}</p>
                                <p>Time: {course.startHour}:00 - {course.startHour + course.duration}:00</p>
                            </div>
                            <div class="card-actions justify-end mt-4">
                                {#if selectedCourses.some(c => c.id === course.id)}
                                    <button 
                                        class="btn btn-error btn-sm"
                                        onclick={() => handleRemoveCourse(course.id)}
                                    >
                                        Remove
                                    </button>
                                {:else}
                                    <button 
                                        class="btn btn-primary btn-sm"
                                        onclick={() => handleAddCourse(course)}
                                    >
                                        Add Course
                                    </button>
                                {/if}
                            </div>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </div>

    <!-- Schedule Preview -->
    <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
            <h2 class="card-title mb-4">Schedule Preview</h2>
            <WeeklySchedule />
        </div>
    </div>
</div>