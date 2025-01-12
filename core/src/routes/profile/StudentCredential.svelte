<!-- src/lib/components/student/StudentCredential.svelte -->
<script lang="ts">
    import { GraduationCap, User, EnvelopeSimple, Buildings, Clock, X } from 'phosphor-svelte';
    import { profileStore, credentialStore } from '$lib/stores/profile.svelte';

    // Get derived values from store using runes
    let profile = $derived(profileStore.profile);
    let academic = $derived(profileStore.academicInfo);
    let avatarUrl = $derived(profileStore.avatarUrl);

    // Handle keyboard navigation
    function handleKeydown(event: KeyboardEvent) {
        if (event.key === 'Escape') {
            credentialStore.toggle();
        }
    }
</script>

<svelte:window onkeydown={handleKeydown}/>

<div 
    class="modal modal-open"
    role="dialog"
    aria-modal="true"
    aria-labelledby="credential-title"
    tabindex="-1"
>
    <!-- Modal backdrop -->
    <button 
        type="button"
        class="modal-backdrop bg-black bg-opacity-50 backdrop-blur-sm"
        onclick={() => credentialStore.toggle()}
        aria-label="Close modal"
    ></button>

    <!-- Modal content -->
    <div 
        class="modal-box bg-base-100 max-w-2xl"
        role="document"
    >
        <!-- Student Credential Content -->
        <div class="p-4">
            <!-- Avatar and Name Section -->
            <div class="flex items-center gap-6 mb-8">
                <div class="avatar">
                    <div class="w-24 rounded-full ring ring-primary ring-offset-base-100 ring-offset-2">
                        <img src={avatarUrl} alt={profile.full_name} />
                    </div>
                </div>

                <div>
                    <h2 id="credential-title" class="text-2xl font-bold">{profile.full_name}</h2>
                    <div class="flex items-center gap-2 text-primary">
                        <GraduationCap weight="duotone" class="w-5 h-5" />
                        <span class="font-semibold">{academic.program}</span>
                    </div>
                    <div class="badge badge-primary mt-2">{profile.status}</div>
                </div>
            </div>

            <!-- Personal Information -->
            <div class="bg-base-200 rounded-lg p-6 space-y-4">
                <h3 class="text-lg font-semibold flex items-center gap-2">
                    <User weight="duotone" class="text-primary" />
                    Personal Information
                </h3>

                <div class="grid gap-4">
                    <div class="flex items-center gap-3">
                        <EnvelopeSimple weight="duotone" class="text-primary w-5 h-5" />
                        <span>{profile.email}</span>
                    </div>
                    <div class="flex items-center gap-3">
                        <Buildings weight="duotone" class="text-primary w-5 h-5" />
                        <span>{academic.faculty}</span>
                    </div>
                    <div class="flex items-center gap-3">
                        <User weight="duotone" class="text-primary w-5 h-5" />
                        <span>ID: {academic.studentId}</span>
                    </div>
                    <div class="flex items-center gap-3">
                        <Clock weight="duotone" class="text-primary w-5 h-5" />
                        <span>Member since {new Date(profile.created_at).getFullYear()}</span>
                    </div>
                </div>
            </div>

            <!-- Academic Information -->
            <div class="mt-6 bg-base-200 rounded-lg p-6">
                <h3 class="text-lg font-semibold flex items-center gap-2 mb-4">
                    <GraduationCap weight="duotone" class="text-primary" />
                    Academic Information
                </h3>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div class="stat bg-base-100 rounded-lg">
                        <div class="stat-title">GPA</div>
                        <div class="stat-value text-primary">{academic.gpa}</div>
                    </div>
                    <div class="stat bg-base-100 rounded-lg">
                        <div class="stat-title">Credits</div>
                        <div class="stat-value text-secondary text-2xl">
                            {academic.creditsCompleted}/{academic.creditsRequired}
                        </div>
                    </div>
                    <div class="stat bg-base-100 rounded-lg">
                        <div class="stat-title">Semester</div>
                        <div class="stat-value">{academic.semester}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
