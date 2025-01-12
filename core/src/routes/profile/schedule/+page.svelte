<!-- src/routes/profile/schedule/+page.svelte -->
<script lang="ts">
    import { 
        CalendarPlus, Clock, ChalkboardTeacher, 
        Books, MapPin, GraduationCap, Download,
        User, Buildings
    } from 'phosphor-svelte';
    
    import WeeklySchedule from './WeeklySchedule.svelte';
    import { scheduleStore } from '$lib/stores/schedule.svelte';
    import { profileStore } from '$lib/stores/profile.svelte';

    // Get derived values
    let subjects = $derived(scheduleStore.subjects);
    let profile = $derived(profileStore.profile);
    let academic = $derived(profileStore.academicInfo);

    // Calculate some stats
    let totalHours = $derived(
        subjects.reduce((acc, subject) => acc + subject.duration, 0)
    );
    
    let uniqueProfessors = $derived(
        new Set(subjects.map(s => s.professor)).size
    );
    
    let uniqueRooms = $derived(
        new Set(subjects.map(s => s.room)).size
    );
</script>

<div class="min-h-screen space-y-8">
    <!-- Header Section -->
    <div class="bg-gradient-to-br from-primary/10 via-base-100 to-base-200 py-12">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-start gap-8">
                <!-- Title and Summary -->
                <div class="space-y-4">
                    <h1 class="text-4xl font-bold flex items-center gap-3">
                        <CalendarPlus weight="duotone" class="text-primary w-10 h-10" />
                        Class Schedule
                    </h1>
                    <p class="text-xl opacity-80 max-w-xl">
                        Manage your weekly academic schedule and course timings for the current semester.
                    </p>
                </div>

                <!-- Quick Stats -->
                <div class="stats bg-base-200 shadow">
                    <div class="stat">
                        <div class="stat-figure text-primary">
                            <Clock weight="duotone" class="w-8 h-8" />
                        </div>
                        <div class="stat-title">Weekly Hours</div>
                        <div class="stat-value">{totalHours}</div>
                        <div class="stat-desc">Hours of instruction</div>
                    </div>
                    
                    <div class="stat">
                        <div class="stat-figure text-secondary">
                            <ChalkboardTeacher weight="duotone" class="w-8 h-8" />
                        </div>
                        <div class="stat-title">Professors</div>
                        <div class="stat-value">{uniqueProfessors}</div>
                        <div class="stat-desc">Teaching staff</div>
                    </div>
                    
                    <div class="stat">
                        <div class="stat-figure text-accent">
                            <Buildings weight="duotone" class="w-8 h-8" />
                        </div>
                        <div class="stat-title">Locations</div>
                        <div class="stat-value">{uniqueRooms}</div>
                        <div class="stat-desc">Different rooms</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 space-y-8">
        <!-- Current Semester Info -->
        <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
                <h2 class="card-title flex items-center gap-2">
                    <GraduationCap weight="duotone" class="text-primary" />
                    Current Semester Overview
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="flex items-center gap-3">
                        <User class="text-primary w-5 h-5" />
                        <div>
                            <div class="font-medium">{profile.full_name}</div>
                            <div class="text-sm opacity-70">{academic.studentId}</div>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <Books class="text-primary w-5 h-5" />
                        <div>
                            <div class="font-medium">{academic.program}</div>
                            <div class="text-sm opacity-70">Semester {academic.semester}</div>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <MapPin class="text-primary w-5 h-5" />
                        <div>
                            <div class="font-medium">{academic.faculty}</div>
                            <div class="text-sm opacity-70">Main Campus</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Weekly Schedule -->
        <WeeklySchedule />

        <!-- Schedule Actions -->
        <div class="flex justify-end gap-4">
            <button class="btn btn-ghost">
                <Download weight="duotone" class="w-5 h-5" />
                Export Schedule
            </button>
            <button class="btn btn-primary">
                <CalendarPlus weight="duotone" class="w-5 h-5" />
                Add to Calendar
            </button>
        </div>
    </div>
</div>