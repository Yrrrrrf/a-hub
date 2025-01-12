<!-- src/lib/components/curriculum/CurriculumMap.svelte -->
<script lang="ts">
    import { fade, fly } from 'svelte/transition';
    import { 
        GraduationCap, BookOpen, ChalkboardTeacher,
        Star, ArrowSquareOut, Books
    } from 'phosphor-svelte';
    import SubjectCard from './SubjectCard.svelte';

    // Props using runes
    let { program, curriculum } = $props<{
        program?: {
            name: string;
            description: string;
        };
        curriculum: Record<string, any[]>;
    }>();

    const typeColors = {
        'basic': 'hsl(var(--b2))',
        'core': 'hsl(var(--p))',
        'advanced': 'hsl(var(--a))'
    };

    const categories = [
        { label: 'Basic', color: 'border-base-300', icon: BookOpen },
        { label: 'Core', color: 'border-primary', icon: Star },
        { label: 'Advanced', color: 'border-secondary', icon: ChalkboardTeacher }
    ];

    const requirements = [
        { label: 'Required', type: 'error' },
        { label: 'Optional', type: 'success' }
    ];
</script>

<div class="card bg-base-100 shadow-xl">
    <div class="card-body p-4">
        {#if program}
            <!-- Header -->
            <div class="text-center space-y-4 mb-8">
                <h1 
                    class="text-4xl font-bold flex items-center justify-center gap-3"
                    in:fly={{ y: -20, duration: 500 }}
                >
                    <GraduationCap weight="duotone" class="text-primary w-10 h-10" />
                    {program.name}
                </h1>
                <p 
                    class="text-xl opacity-80 max-w-3xl mx-auto"
                    in:fly={{ y: 20, duration: 500, delay: 200 }}
                >
                    {program.description}
                </p>
            </div>
        {/if}

        <!-- Legend -->
        <div 
            class="flex flex-wrap justify-center gap-6 mb-8 p-4 bg-base-200 rounded-lg"
            in:fade={{ duration: 300, delay: 400 }}
        >
            <!-- Categories -->
            <div class="flex items-center gap-6">
                {#each categories as cat}
                    <div class="flex items-center gap-2">
                        <div class="w-4 border-l-4 h-4 {cat.color}"></div>
                        <span class="text-sm opacity-80">{cat.label}</span>
                    </div>
                {/each}
            </div>

            <div class="divider divider-horizontal"></div>

            <!-- Requirements -->
            <div class="flex items-center gap-6">
                {#each requirements as req}
                    <div class="flex items-center gap-2">
                        <div class="badge badge-sm badge-{req.type} w-4 h-4 p-0"></div>
                        <span class="text-sm opacity-80">{req.label}</span>
                    </div>
                {/each}
            </div>
        </div>

        <!-- Curriculum Grid -->
        <div class="overflow-x-auto">
            <div class="min-w-[1920px] pb-8">
                <div class="grid grid-cols-9 gap-4">
                    {#each Object.entries(curriculum) as [semester, semesterCourses] (semester)}
                        <div 
                            class="space-y-4"
                            in:fade={{ duration: 300, delay: 200 * parseInt(semester) }}
                        >
                            <!-- Semester Header -->
                            <div class="card bg-base-200">
                                <div class="card-body p-3 items-center">
                                    <h3 class="card-title text-sm">
                                        Semester {semester}
                                    </h3>
                                </div>
                            </div>

                            <!-- Semester Subjects -->
                            <div class="space-y-4">
                                {#each semesterCourses as course, index (course?.id || `empty-${index}`)}
                                    {#if course}
                                        <div in:fade={{ duration: 300 }}>
                                            <SubjectCard
                                                subject={course}
                                                color={typeColors[course.category]}
                                                status="Not Started"
                                                theoreticalHours={4}
                                                practiceHours={2}
                                                isRequired={course.is_required}
                                            />
                                        </div>
                                    {:else}
                                        <div class="h-32 bg-base-200 rounded-lg opacity-25"></div>
                                    {/if}
                                {/each}
                            </div>
                        </div>
                    {/each}
                </div>
            </div>
        </div>
    </div>
</div>