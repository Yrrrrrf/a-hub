<script lang="ts">
    import { Clock, BookOpen, ChalkboardTeacher,Star, Info, CheckCircle, XCircle } from 'phosphor-svelte';

    export type SubjectStatus = 'Not Started' | 'In Progress' | 'Passed' | 'Failed';
    
    // Interface from API
    interface ProgramCurriculum {
        program_id?: string;
        program_code?: string;
        program_name?: string;
        course_id?: string;
        course_code?: string;
        course_title?: string;
        credits?: number;
        is_required?: boolean;
        recommended_semester?: number;
    }

    // Props using runes
    let { subject, status = 'Not Started', color } = $props<{
        subject: ProgramCurriculum;
        status?: SubjectStatus;
        color?: string;
    }>();

    // Local state
    let isHovered = $state(false);

    // Hardcoded mappings (to be moved to proper configuration later)
    const statusConfig = {
        'Not Started': { color: 'bg-base-200', icon: Info },
        'In Progress': { color: 'bg-warning', icon: Clock },
        'Passed': { color: 'bg-success', icon: CheckCircle },
        'Failed': { color: 'bg-error', icon: XCircle }
    };

    // Temporary category mapping based on semester number
    function getSubjectCategory(semester: number = 1) {
        if (semester <= 2) return { type: 'basic', icon: BookOpen, color: 'border-base-300' };
        if (semester <= 5) return { type: 'core', icon: Star, color: 'border-primary' };
        return { type: 'advanced', icon: ChalkboardTeacher, color: 'border-secondary' };
    }

    // Compute category based on semester
    let category = $derived(getSubjectCategory(subject.recommended_semester));

    // Fixed values for now
    const THEORETICAL_HOURS = 4;
    const PRACTICAL_HOURS = 2;
    let totalHours = $derived(THEORETICAL_HOURS + PRACTICAL_HOURS);

    function handleKeydown(e: KeyboardEvent) {
        if (e.key === 'Enter' || e.key === ' ') {
            isHovered = !isHovered;
        }
    }
</script>

<div
    class="transform transition-all duration-300 hover:scale-105 cursor-pointer"
    onmouseenter={() => isHovered = true}
    onmouseleave={() => isHovered = false}
    onkeydown={handleKeydown}
    role="button"
    tabindex="0"
    aria-label={`Course: ${subject.course_title}`}
>
    <div 
        class="w-full h-32 bg-base-100 rounded-lg shadow-lg overflow-hidden relative border-l-4 {category.color}"
        style="background: {color}"
    >
        <!-- Required/Optional Badge -->
        <div class="absolute top-2 right-2">
            <div class="badge badge-sm {subject.is_required ? 'badge-error' : 'badge-success'}">
                {subject.is_required ? 'Required' : 'Optional'}
            </div>
        </div>

        <div class="p-3 h-full relative">
            <!-- Default View -->
            <div class="flex flex-col h-full justify-between {isHovered ? 'opacity-0' : 'opacity-100'} transition-opacity duration-300">
                <div class="flex-grow">
                    <div class="flex items-center gap-2 mb-1">
                        <category.icon weight="duotone" class="w-4 h-4" />
                        <h3 class="font-bold text-sm line-clamp-2">{subject.course_title}</h3>
                    </div>
                    <p class="text-xs opacity-70">{subject.course_code}</p>
                </div>
                
                <div class="flex justify-between items-center text-xs">
                    <div class="badge badge-primary badge-sm">
                        {subject.credits} cr
                    </div>
                    <div class="flex items-center gap-1">
                        <Clock class="w-3 h-3" />
                        <span class="font-medium">{totalHours} hrs</span>
                    </div>
                </div>
            </div>

            <!-- Hover View -->
            <div class="absolute inset-0 bg-base-100 p-3 flex flex-col {isHovered ? 'opacity-100' : 'opacity-0'} transition-opacity duration-300 overflow-y-auto">
                <!-- Status and Category -->
                <!-- <div class="flex items-center gap-2 mb-2">
                    <div class="badge gap-1 {statusConfig[status].color}">
                        <statusConfig[status].icon class="w-3 h-3" />
                        {status}
                    </div>
                    <div class="badge badge-ghost gap-1">
                        <category.icon class="w-3 h-3" />
                        {category.type}
                    </div>
                </div> -->

                <!-- Course Code and Credits -->
                <div class="text-xs mb-2">
                    <p>Code: <span class="font-bold">{subject.course_code}</span></p>
                    <p>Credits: <span class="font-bold">{subject.credits}</span></p>
                    <p>Semester: <span class="font-bold">{subject.recommended_semester}</span></p>
                </div>

                <!-- Hours Breakdown -->
                <div class="text-xs mt-auto space-y-1">
                    <div class="flex justify-between">
                        <span>Theory</span>
                        <span class="font-medium">{THEORETICAL_HOURS} hrs</span>
                    </div>
                    <div class="flex justify-between">
                        <span>Practice</span>
                        <span class="font-medium">{PRACTICAL_HOURS} hrs</span>
                    </div>
                    <div class="flex justify-between font-medium">
                        <span>Total</span>
                        <span>{totalHours} hrs</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>