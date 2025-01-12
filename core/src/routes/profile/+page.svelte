<!-- src/routes/profile/+page.svelte -->
<script lang="ts">
	import { 
		Calendar,
		Clock,
		BookOpen,
		CaretRight,
		FileText,
		Books,
		Star
	} from 'phosphor-svelte';
	
	import { profileStore, credentialStore } from '$lib/stores/profile.svelte';
	import StudentCard from './StudentCard.svelte';
    import StudentCredential from './StudentCredential.svelte';
    import WeeklySchedule from './schedule/WeeklySchedule.svelte';

	let quickLinks = $derived(profileStore.getQuickLinks());
	// Get data from store using derived values
	let courses = $derived(profileStore.currentCourses);
	let activities = $derived(profileStore.recentActivities);
	let library = $derived(profileStore.libraryItems);
	let deadlines = $derived(profileStore.upcomingDeadlines);

	let isCredentialVisible = $derived(credentialStore.isVisible);
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

	<!-- Main Content -->
	<div class="container mx-auto px-4 py-12">
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
			<!-- Left Column -->
			<div class="space-y-8">

				<div class="card bg-base-100 shadow-xl">
					<div class="card-body">
						<h2 class="card-title flex items-center gap-2">
							<Star weight="duotone" class="text-primary" />
							Quick Links
						</h2>
						<div class="space-y-2">
							{#each quickLinks as link}
								<a
									href={link.href}
									class="btn btn-ghost w-full justify-between text-left hover:bg-primary/10 group"
								>
									<span class="flex items-center gap-2">
										<link.icon class="w-5 h-5" />
										{link.text}
									</span>
									<CaretRight class="transition-transform group-hover:translate-x-1 w-5 h-5" />
								</a>
							{/each}
						</div>
					</div>
				</div>

			</div>

			<!-- Main Column -->
			<div class="lg:col-span-2 space-y-8">
				<!-- Current Courses -->
				<div class="card bg-base-100 shadow-xl">
					<div class="card-body">
						<h2 class="card-title flex items-center gap-2">
							<BookOpen weight="duotone" class="text-primary" />
							Current Courses
						</h2>
						<div class="overflow-x-auto">
							<table class="table table-zebra">
								<thead>
									<tr>
										<th>Code</th>
										<th>Course</th>
										<th>Schedule</th>
										<th>Grade</th>
									</tr>
								</thead>
								<tbody>
									{#each courses as course}
										<tr>
											<td>{course.code}</td>
											<td>
												<div>
													<div class="font-bold">{course.name}</div>
													<div class="text-sm opacity-50">{course.professor}</div>
												</div>
											</td>
											<td>
												<div>
													<div>{course.schedule}</div>
													<div class="text-sm opacity-50">{course.room}</div>
												</div>
											</td>
											<td>
												<div class="badge badge-primary">{course.grade}</div>
											</td>
										</tr>
									{/each}
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<!-- Recent Activities -->
				<div class="card bg-base-100 shadow-xl">
					<div class="card-body">
						<h2 class="card-title flex items-center gap-2">
							<!-- <Activity weight="duotone" class="text-primary" /> -->
							Recent Activities
						</h2>
						<div class="space-y-4">
							{#each activities as activity}
								<div class="flex items-center justify-between p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
									<div class="flex items-center gap-4">
										{#if activity.type === 'submission'}
											<FileText weight="duotone" class="text-primary" />
										{:else if activity.type === 'attendance'}
											<Calendar weight="duotone" class="text-secondary" />
										{:else}
											<Books weight="duotone" class="text-accent" />
										{/if}
										<div>
											<div class="font-semibold">{activity.action}</div>
											<div class="text-sm opacity-70">{activity.date}</div>
										</div>
									</div>
									<span class="badge badge-ghost">{activity.status}</span>
								</div>
							{/each}
						</div>
					</div>
				</div>

				<!-- Deadlines & Library Items Grid -->
				<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
					<!-- Upcoming Deadlines -->
					<div class="card bg-base-100 shadow-xl">
						<div class="card-body">
							<h2 class="card-title flex items-center gap-2">
								<Clock weight="duotone" class="text-primary" />
								Deadlines
							</h2>
							<div class="space-y-4">
								{#each deadlines as deadline}
									<div class="flex flex-col p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
										<div class="font-semibold">{deadline.task}</div>
										<div class="text-sm opacity-70">{deadline.course}</div>
										<div class="mt-2">
											<span class="badge badge-primary">{deadline.dueDate}</span>
										</div>
									</div>
								{/each}
							</div>
						</div>
					</div>

					<!-- Library Items -->
					<div class="card bg-base-100 shadow-xl">
						<div class="card-body">
							<h2 class="card-title flex items-center gap-2">
								<Books weight="duotone" class="text-primary" />
								Library Items
							</h2>
							<div class="space-y-4">
								{#each library as item}
									<div class="flex flex-col p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
										<div class="font-semibold">{item.title}</div>
										<div class="text-sm flex justify-between items-center mt-2">
											<span class="opacity-70">Due: {item.dueDate}</span>
											<span class="badge badge-ghost">{item.status}</span>
										</div>
									</div>
								{/each}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
