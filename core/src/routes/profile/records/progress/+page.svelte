<!-- src/routes/profile/records/progress/+page.svelte -->
<script lang="ts">
    import {
        GraduationCap, ChartLine, Trophy,
        Books, Download, ArrowSquareOut
    } from 'phosphor-svelte';
    import CurriculumMap from '$lib/components/CurriculumMap.svelte';
    import { profileStore } from '$lib/stores/profile.svelte';

    // Get profile data
    let profile = $derived(profileStore.profile);
    let academic = $derived(profileStore.academicInfo);

    // Sample curriculum data (to be replaced with store)
    const program = {
        name: "Computer Science",
        description: "A comprehensive program designed to prepare students for careers in software development, systems architecture, and computer science research."
    };

    // Temp stats (to be calculated from actual data)
    const progressStats = {
        completedCredits: academic.creditsCompleted,
        totalCredits: academic.creditsRequired,
        completedCourses: 12,
        totalCourses: 48,
        currentGPA: academic.gpa,
        expectedGraduation: "2026"
    };
</script>

<div class="min-h-screen space-y-8">
    <!-- Header Section -->
    <div class="bg-gradient-to-br from-primary/10 via-base-100 to-base-200 py-12">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-start gap-8">
                <!-- Title and Description -->
                <div class="space-y-4">
                    <h1 class="text-4xl font-bold flex items-center gap-3">
                        <ChartLine weight="duotone" class="text-primary w-10 h-10" />
                        Academic Progress
                    </h1>
                    <p class="text-xl opacity-80 max-w-xl">
                        Track your progress through your degree program and monitor your academic achievements.
                    </p>
                </div>

                <!-- Quick Actions -->
                <div class="flex gap-4">
                    <button class="btn btn-ghost">
                        <Download class="w-5 h-5" />
                        Export Progress
                    </button>
                    <button class="btn btn-primary">
                        <ArrowSquareOut class="w-5 h-5" />
                        View Requirements
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Progress Overview -->
    <div class="container mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <!-- Overall Progress Card -->
            <div class="card bg-base-100 shadow-xl">
                <div class="card-body">
                    <h3 class="card-title flex items-center gap-2">
                        <Trophy weight="duotone" class="text-primary" />
                        Overall Progress
                    </h3>
                    <div class="space-y-4">
                        <div>
                            <div class="flex justify-between text-sm mb-1">
                                <span>Credits Completed</span>
                                <span>{progressStats.completedCredits}/{progressStats.totalCredits}</span>
                            </div>
                            <progress 
                                class="progress progress-primary w-full" 
                                value={progressStats.completedCredits} 
                                max={progressStats.totalCredits}
                            ></progress>
                        </div>
                        <div>
                            <div class="flex justify-between text-sm mb-1">
                                <span>Courses Completed</span>
                                <span>{progressStats.completedCourses}/{progressStats.totalCourses}</span>
                            </div>
                            <progress 
                                class="progress progress-secondary w-full" 
                                value={progressStats.completedCourses} 
                                max={progressStats.totalCourses}
                            ></progress>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Academic Standing Card -->
            <div class="card bg-base-100 shadow-xl">
                <div class="card-body">
                    <h3 class="card-title flex items-center gap-2">
                        <GraduationCap weight="duotone" class="text-primary" />
                        Academic Standing
                    </h3>
                    <div class="stats stats-vertical shadow">
                        <div class="stat">
                            <div class="stat-title">Current GPA</div>
                            <div class="stat-value text-primary">{progressStats.currentGPA}</div>
                            <div class="stat-desc">Last updated March 2024</div>
                        </div>
                        <div class="stat">
                            <div class="stat-title">Expected Graduation</div>
                            <div class="stat-value text-secondary">{progressStats.expectedGraduation}</div>
                            <div class="stat-desc">Based on current progress</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Current Semester Card -->
            <div class="card bg-base-100 shadow-xl">
                <div class="card-body">
                    <h3 class="card-title flex items-center gap-2">
                        <Books weight="duotone" class="text-primary" />
                        Current Semester
                    </h3>
                    <div class="stats stats-vertical shadow">
                        <div class="stat">
                            <div class="stat-title">Enrolled Credits</div>
                            <div class="stat-value">15</div>
                            <div class="stat-desc">5 Courses</div>
                        </div>
                        <div class="stat">
                            <div class="stat-title">Semester Progress</div>
                            <div class="stat-value text-accent">75%</div>
                            <div class="stat-desc text-success">On track</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Legend -->
        <div class="card bg-base-100 shadow-xl mb-8">
            <div class="card-body p-4">
                <h3 class="card-title text-sm mb-4">Course Status Legend</h3>
                <div class="flex flex-wrap gap-6 justify-center">
                    <div class="flex items-center gap-2">
                        <div class="badge badge-success badge-sm">●</div>
                        <span class="text-sm">Completed</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <div class="badge badge-warning badge-sm">●</div>
                        <span class="text-sm">In Progress</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <div class="badge badge-error badge-sm">●</div>
                        <span class="text-sm">Failed/Retake</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <div class="badge badge-ghost badge-sm">●</div>
                        <span class="text-sm">Not Started</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Curriculum Map -->
        <CurriculumMap
            program={{
                // todo: DO NOT HARDCODE THIS!!!
                // todo: DO NOT HARDCODE THIS!!!
                // todo: DO NOT HARDCODE THIS!!!
                // todo: DO NOT HARDCODE THIS!!!
                // todo: DO NOT HARDCODE THIS!!!
                // todo: DO NOT HARDCODE THIS!!!
                name: "Computer Engineering",
                description: "A comprehensive program in computer engineering..."
            }}
        />

    </div>
</div>