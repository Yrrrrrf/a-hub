<script lang="ts">
	import { fade, fly } from 'svelte/transition';
	import {
		GraduationCap,
		BookOpen,
		ChalkboardTeacher,
		Star
	} from 'phosphor-svelte';
	import { onMount } from 'svelte';

	// todo: REMOVE 'ts-forge' FROM 'a-huub'!!!
	import { createCrudOperations, BaseClient } from 'ts-forge';
	import { getForge, apiStore } from 'rune-lab';
	import SubjectCard from './SubjectCard.svelte';

	interface program_curriculum {
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

	interface Program {
		name: string;
		description: string;
	}

	// Props using runes - make courses optional since we'll fetch them
	let { program } = $props<{
		program?: Program;
	}>();

	// State management with runes
	let isLoading = $state(true);
	let error = $state<string | null>(null);
	let data = $state<program_curriculum[]>([]);
	let curriculumMap = $state<Record<number, program_curriculum[]>>({});

	// Fetch data on mount
	onMount(async () => {
		const baseClient: BaseClient = new BaseClient(apiStore.URL);
		console.log('Base client:', apiStore.URL);
		try {

			const t_metadata = (await getForge()).getTable('academic', 'program_curriculum');
			if (!t_metadata) {
				throw new Error('Program curriculum table not found');
			}

			const crudOps = createCrudOperations<program_curriculum>(
				baseClient,
				t_metadata
			);

			data = await crudOps.findMany({
				// Fix this hahaha, my fault completely...
				where: { program_code: 'ICO' }
			});
			// console.log('fMany Count:', (filtered || []).length);
			console.log('Filtered:', data);

			// Create map directly
			const map: Record<number, program_curriculum[]> = {};
			data.forEach((course) => {
				const semester = course.recommended_semester || 1;
				console.log(
					'Processing course:',
					course.course_code,
					'for semester:',
					semester
				);

				if (!map[semester]) {
					map[semester] = [];
				}
				map[semester].push(course);
			});
			curriculumMap = map;
		} catch (e) {
			error = e instanceof Error ? e.message : 'Failed to load curriculum data';
		} finally {
			isLoading = false;
		}
	});

	// Category configuration
	const categories = [
		{ label: 'Basic', color: 'border-base-300', icon: BookOpen },
		{ label: 'Core', color: 'border-primary', icon: Star },
		{ label: 'Advanced', color: 'border-secondary', icon: ChalkboardTeacher }
	];

	const requirements = [
		{ label: 'Required', type: 'error' },
		{ label: 'Optional', type: 'success' }
	];

	// added
	function getSemesterName(semesterNumber: number) {
		const semesterNames = [
			'1st Semester',
			'2nd Semester',
			'3rd Semester',
			'4th Semester',
			'5th Semester',
			'6th Semester',
			'7th Semester',
			'8th Semester',
			'9th Semester'
		];
		return semesterNames[semesterNumber - 1] || `Semester ${semesterNumber}`;
	}
</script>

<div class="card bg-base-100 shadow-xl">
	<div class="card-body p-4">
		{#if isLoading}
			<div class="flex justify-center items-center min-h-[400px]">
				<span class="loading loading-spinner loading-lg text-primary"></span>
			</div>
		{:else if error}
			<div class="alert alert-error">
				<span>{error}</span>
			</div>
		{:else}
			{#if program}
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

			<div
				class="flex flex-wrap justify-center gap-6 mb-8 p-4 bg-base-200 rounded-lg"
				in:fade={{ duration: 300, delay: 400 }}
			>
				<div class="flex items-center gap-6">
					{#each categories as cat}
						<div class="flex items-center gap-2">
							<div class="w-4 border-l-4 h-4 {cat.color}"></div>
							<span class="text-sm opacity-80">{cat.label}</span>
						</div>
					{/each}
				</div>

				<div class="divider divider-horizontal"></div>

				<div class="flex items-center gap-6">
					{#each requirements as req}
						<div class="flex items-center gap-2">
							<div class="badge badge-sm badge-{req.type} w-4 h-4 p-0"></div>
							<span class="text-sm opacity-80">{req.label}</span>
						</div>
					{/each}
				</div>
			</div>

			<div class="overflow-x-auto">
				{#if data.length === 0}
					<div class="text-center py-8">
						<p class="text-lg opacity-70">No curriculum data available</p>
					</div>
				{:else}
					<div class="min-w-[1920px] pb-8">
						<div class="grid grid-cols-9 gap-4">
							{#each Object.entries(curriculumMap) as [semester, semesterCourses]}
								<div
									class="space-y-4"
									in:fade={{ duration: 300, delay: 200 * parseInt(semester) }}
								>
									<div class="card bg-base-200">
										<div class="card-body p-3 items-center">
											<h3 class="card-title text-sm">
												{getSemesterName(parseInt(semester))}
											</h3>
										</div>
									</div>

									<div class="space-y-4">
										{#each semesterCourses as course (course.course_id)}
											{#if course}
												<div in:fade={{ duration: 300 }}>
													<SubjectCard subject={course} status="Not Started" />
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
				{/if}
			</div>
		{/if}
	</div>
</div>