<!-- src/routes/profile/+page.svelte -->
<script lang="ts">
	import { Calendar, Clock, BookOpen, CaretRight, ArrowLeft, Star, ListChecks, Gear } from 'phosphor-svelte';

	import { credentialStore } from '$lib/stores/profile.svelte';
	import StudentCard from './StudentCard.svelte';
    import StudentCredential from './StudentCredential.svelte';
    import CurrentCourses from './CurrentCourses.svelte';
    import RecientActivities from './RecientActivities.svelte';

	let isCredentialVisible = $derived(credentialStore.isVisible);

    // Quick Links
	interface QuickLink {
		icon: any; // Use a more specific type if possible, like a Phosphor icon type
		text: string;
		href: string;
	}

    let quickLinks = $state<QuickLink[]>([
        {
            icon: BookOpen,
            text: 'Academic Records',
            href: '/profile/records'
        },
        {
            icon: Calendar,
            text: 'Course Registration',
            href: '/profile/course-registration' // Replace with your actual route
        },
        {
            icon: Clock,
            text: 'Schedule',
            href: '/profile/schedule' // Replace with your actual route
        },
        {
            icon: ListChecks,
            text: 'Requests',
            href: '/profile/requests'
        },
        {
            icon: Gear,
            text: 'Settings',
            href: '/profile/settings'
        },
    ]);

	let isCollapsed = $state(false);

</script>

<!-- Student Credential Modal -->
{#if isCredentialVisible}
	<StudentCredential />
{/if}

<div class="min-h-screen bg-base-100">
	<!-- Profile Header -->
	<div class="bg-gradient-to-br from-primary/10 via-base-100 to-base-200 py-12">
		<div class="container mx-auto px-4">
			<StudentCard />
		</div>
	</div>

	<!-- Main grid layout with dynamic columns -->
	<div class="container mx-auto px-4 py-12">
		<div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
			<!-- Collapsible Left Column -->
			<div class={`space-y-8 transition-all duration-300 ${isCollapsed ? 'lg:col-span-1' : 'lg:col-span-3'}`}>
				<div class="card bg-base-100 shadow-xl overflow-hidden">
					<!-- Toggle button -->
					<button 
						class="absolute right-0 top-6 -mr-3 btn btn-circle btn-sm btn-ghost hover:bg-base-200 z-10"
						onclick={() => isCollapsed = !isCollapsed}
						aria-label={isCollapsed ? "Expand quick links" : "Collapse quick links"}
					>
						<ArrowLeft 
							class={`w-4 h-4 transition-transform duration-300 ${isCollapsed ? 'rotate-180' : ''}`}
						/>
					</button>

					<div class="card-body p-4">
						<h2 class={`card-title flex items-center gap-2 ${isCollapsed ? 'sr-only' : ''}`}>
							<Star weight="duotone" class="text-primary" />
							Quick Links
						</h2>
						<div class="space-y-2">
							{#each quickLinks as link}
								<a href={link.href} title={isCollapsed ? link.text : ''}
									class={`btn ${isCollapsed ? 'btn-ghost btn-circle' : 'btn-ghost w-full justify-between'} 
									text-left hover:bg-primary/10 group transition-all duration-300`}
								>
									<span class="flex items-center gap-2">
										<link.icon class="w-5 h-5" />
										{#if !isCollapsed}
											<span>{link.text}</span>
										{/if}
									</span>
									{#if !isCollapsed}
										<CaretRight class="transition-transform group-hover:translate-x-1 w-5 h-5" />
									{/if}
								</a>
							{/each}
						</div>
					</div>
				</div>
			</div>

			<!-- Main Column - expands when sidebar is collapsed -->
			<div class={`space-y-8 transition-all duration-300 ${isCollapsed ? 'lg:col-span-11' : 'lg:col-span-9'}`}>
				<CurrentCourses />
				<RecientActivities />
			</div>
		</div>

	</div>
</div>
