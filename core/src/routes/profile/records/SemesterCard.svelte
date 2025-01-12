<!-- src/lib/components/academic/SemesterCard.svelte -->
<script lang="ts">
    import { Calendar, Sigma, Trophy } from 'phosphor-svelte';
    import type { Semester } from '$lib/stores/records.svelte';

    // Props using runes
    let { semester } = $props<{
        semester: Semester;
    }>();

    // Computed values
    let totalCredits = $derived(
        semester.courses.reduce((
            sum: number, 
            course: { credits: number }
        ) => sum + course.credits, 0)
    );

    function getGradeColor(grade: string): string {
        switch (grade) {
            case 'A': return 'bg-success text-success-content';
            case 'A-': return 'bg-success text-success-content';
            case 'B+': return 'bg-info text-info-content';
            case 'B': return 'bg-info text-info-content';
            default: return 'bg-warning text-warning-content';
        }
    }
</script>

<div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all">
    <div class="card-body">
        <!-- Header -->
        <div class="flex flex-wrap items-center justify-between gap-4 mb-4">
            <div class="flex items-center gap-3">
                <Calendar weight="duotone" class="w-6 h-6 text-primary" />
                <h3 class="text-2xl font-bold">
                    {semester.semester} {semester.year}
                </h3>
            </div>
            <div class="flex items-center gap-4">
                <div class="flex items-center gap-2">
                    <Sigma weight="duotone" class="w-5 h-5 text-primary" />
                    <span class="text-sm opacity-70">Credits: {totalCredits}</span>
                </div>
                <div class="flex items-center gap-2">
                    <Trophy weight="duotone" class="w-5 h-5 text-primary" />
                    <div class="badge badge-primary">GPA: {semester.gpa}</div>
                </div>
            </div>
        </div>

        <!-- Courses Table -->
        <div class="overflow-x-auto">
            <table class="table w-full">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Course</th>
                        <th class="text-center">Credits</th>
                        <th class="text-center">Grade</th>
                    </tr>
                </thead>
                <tbody>
                    {#each semester.courses as course}
                        <tr class="hover">
                            <td class="font-mono">{course.code}</td>
                            <td>{course.name}</td>
                            <td class="text-center">{course.credits}</td>
                            <td class="text-center">
                                <span class="badge {getGradeColor(course.grade)}">
                                    {course.grade}
                                </span>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>

        <!-- Summary -->
        <div class="mt-4 flex flex-wrap justify-end gap-4 text-sm opacity-70">
            <span>Total Courses: {semester.courses.length}</span>
            <span>|</span>
            <span>Total Credits: {totalCredits}</span>
            <span>|</span>
            <span>GPA: {semester.gpa}</span>
        </div>
    </div>
</div>