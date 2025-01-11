<script lang="ts">
    import { academicRecords } from '$lib/stores/records.svelte';
    import { GraduationCap, MagnifyingGlass } from 'phosphor-svelte';
    
    let loading = $state(false);
    let searchTerm = $state('');
    let semesters = $derived(academicRecords.semesters);
    
    // Filter semesters based on search
    let filteredSemesters = $derived(
        searchTerm === ''
            ? semesters
            : semesters.filter(semester => 
                semester.semester.toLowerCase().includes(searchTerm.toLowerCase()) ||
                semester.year.toString().includes(searchTerm) ||
                semester.courses.some(course => 
                    course.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
                    course.name.toLowerCase().includes(searchTerm.toLowerCase())
                )
            )
    );

    function handlePrint() {
        window.print();
    }

    function handleReset() {
        academicRecords.reset();
    }
</script>

<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold flex items-center gap-2">
            <GraduationCap class="text-primary" weight="duotone" size={32} />
            Academic Records
        </h1>

        <!-- Search bar -->
        <div class="join">
            <input
                type="text"
                bind:value={searchTerm}
                placeholder="Search courses..."
                class="input input-bordered join-item"
            />
            <button class="btn btn-primary join-item" aria-label="Search">
                <MagnifyingGlass size={20} />
            </button>
        </div>
    </div>

    {#if loading}
        <div class="flex justify-center py-12">
            <span class="loading loading-spinner loading-lg"></span>
        </div>
    {:else}
        <div class="space-y-8">
            {#each filteredSemesters as semester (semester.id)}
                <div class="card bg-base-100">
                    <div class="card-body">
                        <h3 class="text-xl font-semibold flex items-center gap-2">
                            {semester.semester} {semester.year}
                            <span class="badge badge-primary">GPA: {semester.gpa}</span>
                        </h3>
                        
                        <div class="overflow-x-auto">
                            <table class="table w-full">
                                <thead>
                                    <tr>
                                        <th>Course Code</th>
                                        <th>Course Name</th>
                                        <th>Credits</th>
                                        <th>Grade</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {#each semester.courses as course}
                                        <tr class="hover">
                                            <td>{course.code}</td>
                                            <td>{course.name}</td>
                                            <td>{course.credits}</td>
                                            <td>{course.grade}</td>
                                        </tr>
                                    {/each}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            {/each}
        </div>

        <div class="flex justify-end gap-4 mt-8">
            <button class="btn btn-ghost" onclick={handleReset}>
                Reset
            </button>
            <button class="btn btn-primary" onclick={handlePrint}>
                Print Record
            </button>
        </div>
    {/if}
</div>

<style>
    /* Add print-specific styles */
    @media print {
        .btn, input, .join {
            display: none;
        }
    }
</style>