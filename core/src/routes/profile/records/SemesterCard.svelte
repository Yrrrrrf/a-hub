<!-- src/lib/components/academic/SemesterCard.svelte -->
<script lang="ts">
    import { Calendar, Sigma, Trophy } from 'phosphor-svelte';
    import type { Semester } from '$lib/stores/records.svelte';
    import type { Subject } from '$lib/stores/schedule.svelte';

    // Props using runes
    let { semester } = $props<{
        semester: Semester;
    }>();

    // Helper function for credits (since they're not in Subject interface)
    function getSubjectCredits(subject: Subject): number {
        return subject.duration; // Using duration as credits for now
    }

    // Computed values
    let totalCredits = $derived(
        semester.subjects.reduce((sum: number, subject: Subject) => sum + getSubjectCredits(subject), 0)
    );

    // Mock grades based on semester progression
    function getGrade(subject: Subject): string {
        const grades = ['A', 'A-', 'B+', 'B', 'B-'];
        return grades[Math.floor(Math.random() * 3)]; // Just for demo
    }

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
                    <span class="text-sm opacity-70">Hours: {totalCredits}</span>
                </div>
                <div class="flex items-center gap-2">
                    <Trophy weight="duotone" class="w-5 h-5 text-primary" />
                    <div class="badge badge-primary">GPA: {semester.gpa}</div>
                </div>
            </div>
        </div>

        <!-- Subjects Table -->
        <div class="overflow-x-auto">
            <table class="table w-full">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Subject</th>
                        <th>Professor</th>
                        <th class="text-center">Hours</th>
                        <th class="text-center">Grade</th>
                    </tr>
                </thead>
                <tbody>
                    {#each semester.subjects as subject}
                        <tr class="hover">
                            <td class="font-mono">{subject.id}</td>
                            <td>
                                <div class="flex items-center gap-2">
                                    <subject.icon weight="duotone" class="w-4 h-4" style="color: {subject.color}" />
                                    <span>{subject.name}</span>
                                </div>
                            </td>
                            <td>{subject.professor || 'TBD'}</td>
                            <td class="text-center">{subject.duration}</td>
                            <td class="text-center">
                                <span class="badge {getGradeColor(getGrade(subject))}">
                                    {getGrade(subject)}
                                </span>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>

        <!-- Summary -->
        <div class="mt-4 flex flex-wrap justify-end gap-4 text-sm opacity-70">
            <span>Total Subjects: {semester.subjects.length}</span>
            <span>|</span>
            <span>Total Hours: {totalCredits}</span>
            <span>|</span>
            <span>GPA: {semester.gpa}</span>
        </div>
    </div>
</div>