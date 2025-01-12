<!-- src/lib/components/curriculum/SubjectCard.svelte -->
<script lang="ts">
    import { 
        Clock, BookOpen, ChalkboardTeacher,
        Star, Info, CheckCircle, Warning,
        XCircle
    } from 'phosphor-svelte';

    type SubjectStatus = 'Not Started' | 'In Progress' | 'Passed' | 'Failed';
    type SubjectType = 'basic' | 'core' | 'advanced';

    // Props using runes
    let { subject, status, grade, color, theoreticalHours, practiceHours, isRequired } = $props<{
        subject: {
            id: string;
            code: string;
            title: string;
            description: string;
            credits: number;
            is_active: boolean;
            category: SubjectType;
        };
        status?: SubjectStatus;
        grade?: number;
        color?: string;
        theoreticalHours?: number;
        practiceHours?: number;
        isRequired?: boolean;
    }>();

    // Local state
    let isHovered = $state(false);

    // Computed values
    let totalHours = $derived((theoreticalHours || 0) + (practiceHours || 0));

    const statusConfig = {
        'Not Started': { color: 'bg-base-200', icon: Info },
        'In Progress': { color: 'bg-warning', icon: Clock },
        'Passed': { color: 'bg-success', icon: CheckCircle },
        'Failed': { color: 'bg-error', icon: XCircle }
    };

    const typeConfig = {
        'basic': { color: 'border-base-300', icon: BookOpen },
        'core': { color: 'border-primary', icon: Star },
        'advanced': { color: 'border-secondary', icon: ChalkboardTeacher }
    };

    function truncate(str: string, n: number) {
        return (str.length > n) ? str.slice(0, n-1) + '...' : str;
    }

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
>
    <div 
        class="w-full h-32 bg-base-100 rounded-lg shadow-lg overflow-hidden relative border-l-4 {typeConfig[subject.category].color}"
        style="background: {color}"
    >
        <!-- Required/Optional Badge -->
        <div class="absolute top-2 right-2">
            <div class="badge badge-sm {isRequired ? 'badge-error' : 'badge-success'}">
                {isRequired ? 'Required' : 'Optional'}
            </div>
        </div>

        <div class="p-3 h-full relative">
            <!-- Default View -->
            <div class="flex flex-col h-full justify-between {isHovered ? 'opacity-0' : 'opacity-100'} transition-opacity duration-300">
                <div class="flex-grow">
                    <div class="flex items-center gap-2 mb-1">
                        <svelte:component this={typeConfig[subject.category].icon} weight="duotone" class="w-4 h-4" />
                        <h3 class="font-bold text-sm line-clamp-2">{subject.title}</h3>
                    </div>
                    <p class="text-xs opacity-70">{subject.code}</p>
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
                <div class="flex items-center gap-2 mb-2">
                    <div class="badge gap-1 {statusConfig[status || 'Not Started'].color}">
                        <svelte:component this={statusConfig[status || 'Not Started'].icon} class="w-3 h-3" />
                        {status}
                    </div>
                    <div class="badge badge-ghost gap-1">
                        <svelte:component this={typeConfig[subject.category].icon} class="w-3 h-3" />
                        {subject.category}
                    </div>
                </div>

                <!-- Grade if available -->
                {#if grade !== undefined}
                    <p class="text-xs mb-2">
                        Grade: <span class="font-bold">{grade}</span>
                    </p>
                {/if}

                <!-- Description -->
                <p class="text-xs mb-2 opacity-70">{truncate(subject.description, 100)}</p>

                <!-- Hours Breakdown -->
                <div class="text-xs mt-auto space-y-1">
                    <div class="flex justify-between">
                        <span>Theory</span>
                        <span class="font-medium">{theoreticalHours} hrs</span>
                    </div>
                    <div class="flex justify-between">
                        <span>Practice</span>
                        <span class="font-medium">{practiceHours} hrs</span>
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