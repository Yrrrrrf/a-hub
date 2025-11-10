<!-- src/lib/components/student/StudentCard.svelte -->
<script lang="ts">
    import { GraduationCap, Star, Books, Calendar } from 'phosphor-svelte';
    import { profileStore, credentialStore } from '$lib/stores/profile.svelte';

    // Get derived values from store using runes
    let profile = $derived(profileStore.profile);
    let academic = $derived(profileStore.academicInfo);
    let avatarUrl = $derived(profileStore.avatarUrl);
</script>

<div class="flex flex-col md:flex-row gap-8 items-start">
    <!-- Avatar and Basic Info -->
    <div class="flex flex-col items-center md:items-start gap-6">
        <button 
            type="button"
            onclick={() => credentialStore.toggle()}
            onkeydown={(e) => e.key === 'Enter' && credentialStore.toggle()}
            class="cursor-pointer transition-all hover:brightness-90"
            aria-label="Toggle Credential"
        >
            <!-- Avatar with click handler and hover effect -->
            <div class="avatar">
                <div class="w-32 rounded-full ring ring-primary ring-offset-base-100 ring-offset-2">
                    <img src={avatarUrl} alt={profile?.fullName} />
                </div>
            </div>
        </button>
    </div>
    
    {#if profile}
        <div class="text-center md:text-left space-y-2">
            <h1 class="text-3xl font-bold">{profile.fullName}</h1>
            <div class="flex items-center gap-2 text-primary font-semibold">
                <GraduationCap weight="duotone" class="w-5 h-5" />
                {academic.program}
            </div>
            <div class="badge badge-primary">{profile.status}</div>
        </div>
    {/if}

    <!-- Academic Stats -->
    <div class="flex-1 grid grid-cols-1 md:grid-cols-3 gap-4">
        <!-- GPA -->
        <div class="stat bg-base-100 shadow-lg rounded-box">
            <div class="stat-figure text-primary">
                <Star weight="duotone" size={32} />
            </div>
            <div class="stat-title">GPA</div>
            <div class="stat-value text-primary">{academic.gpa}</div>
            <div class="stat-desc">Current Standing</div>
        </div>
        
        <!-- Credits with Mini Progress Bar -->
        <div class="stat bg-base-100 shadow-lg rounded-box">
            <div class="stat-figure text-secondary">
                <Books weight="duotone" size={32} />
            </div>
            <div class="stat-title">Credits</div>
            <div class="stat-value text-secondary">
                {academic.creditsCompleted}
                <span class="text-lg">/{academic.creditsRequired}</span>
            </div>
            <div class="w-full bg-base-300 rounded-full h-1.5 mt-2">
                <div 
                    class="bg-secondary h-1.5 rounded-full transition-all" 
                    style="width: {(academic.creditsCompleted / academic.creditsRequired) * 100}%"
                ></div>
            </div>
        </div>
        
        <!-- Semester -->
        <div class="stat bg-base-100 shadow-lg rounded-box">
            <div class="stat-figure text-accent">
                <Calendar weight="duotone" size={32} />
            </div>
            <div class="stat-title">Semester</div>
            <div class="stat-value">{academic.semester}</div>
            <div class="stat-desc">Current</div>
        </div>
    </div>

</div>
