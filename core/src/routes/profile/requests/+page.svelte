<script lang="ts">
    import { requestsStore, type RequestType, type RequestForm, type RequestFormField } from '$lib/stores/request.svelte';

    let requestTypes = $derived(requestsStore.getRequestTypes());
    let requestForms = $derived(requestsStore.requestForms);
    let selectedCategory = $state<string>('All');
    let selectedRequestType = $state<RequestType | null>(null);
    let requestForm = $derived(
        selectedRequestType?.formKey ? requestsStore.getRequestForm(selectedRequestType.formKey) : null
    );

    let searchTerm = $state('');

    // Filtered request types based on search term and category
    let filteredRequestTypes = $derived(
        requestTypes.filter(
            (type) =>
                (selectedCategory === 'All' || type.category === selectedCategory) &&
                type.title.toLowerCase().includes(searchTerm.toLowerCase())
        )
    );

    function handleRequestTypeClick(type: RequestType) {
        selectedRequestType = type;
    }

    function closeForm() {
        selectedRequestType = null;
    }

    function handleSubmit(formKey: string, formData: any) {
        console.log('Form submitted:', formKey, formData);
        selectedRequestType = null;
    }

    function getFormData(formKey: string): any {
        const form = document.querySelector('form') as HTMLFormElement;
        const formData = new FormData(form);
        const data: any = {};

        requestForms[formKey].forEach((field: RequestFormField) => {
            if (field.type === 'select') {
                const selectElement = document.getElementById(field.id) as HTMLSelectElement;
                data[field.id] = selectElement.value;
            } else if (field.type === 'file') {
                const fileInput = document.getElementById(field.id) as HTMLInputElement;
                data[field.id] = fileInput.files ? fileInput.files[0] : null;
            } else {
                const inputElement = document.getElementById(field.id) as HTMLInputElement;
                data[field.id] = inputElement.value;
            }
        });

        return data;
    }
</script>

<div class="p-4 bg-base-200">
    <div class="join w-full flex items-center gap-4">
        <input
            type="text"
            placeholder="Search requests..."
            class="input input-bordered w-full"
            bind:value={searchTerm}
        />
    </div>
    <div class="flex justify-center space-x-4 mt-4">
        <button
            class="btn btn-sm {selectedCategory === 'All' ? 'btn-primary' : 'btn-ghost'}"
            onclick={() => (selectedCategory = 'All')}
        >
            All
        </button>
        {#each ['Academic', 'Financial', 'Administrative', 'IT', 'Other'] as category}
            <button
                class="btn btn-sm {selectedCategory === category ? 'btn-primary' : 'btn-ghost'}"
                onclick={() => (selectedCategory = category)}
            >
                {category}
            </button>
        {/each}
    </div>
</div>

<div class="container mx-auto px-4 py-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {#each filteredRequestTypes as requestType}
        <div
		class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow cursor-pointer"
		onclick={() => handleRequestTypeClick(requestType)}
		onkeydown={(e) => e.key === 'Enter' && handleRequestTypeClick(requestType)}
		role="button"
		tabindex="0"
	>
		<div class="card-body">
			<div class="flex items-center gap-4">
				<requestType.icon class="w-10 h-10 text-primary" />
				<div>
					<h2 class="card-title text-lg">{requestType.title}</h2>
					<p class="text-base-content/70">{requestType.description}</p>
				</div>
			</div>
		</div>
	</div>
    {/each}
</div>

{#if selectedRequestType && requestForm}
    <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
        <div class="modal-box bg-base-100 p-6 rounded-lg shadow-2xl w-full max-w-2xl">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-2xl font-bold">{selectedRequestType.title}</h3>
				<button 
					class="btn btn-circle btn-ghost" 
					onclick={closeForm}
					aria-label="Close form"
				>
					<svg
						xmlns="http://www.w3.org/2000/svg"
						class="h-6 w-6"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
					>
						<path 
							stroke-linecap="round" 
							stroke-linejoin="round" 
							stroke-width="2" 
							d="M6 18L18 6M6 6l12 12" 
						/>
					</svg>
				</button>
			</div>
            <p class="text-sm mb-4">{selectedRequestType.description}</p>
            <form
                onsubmit={() => handleSubmit(selectedRequestType?.formKey!, getFormData(selectedRequestType?.formKey!))}
            >
                {#each requestForm as field (field.id)}
                    <div class="form-control mb-4">
                        <label for={field.id} class="label font-medium">
                            <span class="label-text">{field.label}</span>
                            {#if field.required}
                                <span class="text-error">*</span>
                            {/if}
                        </label>
                        {#if field.type === 'text' || field.type === 'number'}
                            <input
                                id={field.id}
                                type={field.type}
                                placeholder={field.placeholder}
                                class="input input-bordered"
                                required={field.required}
                            />
                        {:else if field.type === 'textarea'}
                            <textarea
                                id={field.id}
                                placeholder={field.placeholder}
                                class="textarea textarea-bordered"
                                required={field.required}
                            ></textarea>
                        {:else if field.type === 'select'}
                            <select id={field.id} class="select select-bordered" required={field.required}>
                                {#if field.options}
                                    {#each field.options as option}
                                        <option value={option}>{option}</option>
                                    {/each}
                                {/if}
                            </select>
                        {:else if field.type === 'date'}
                            <input id={field.id} type="date" class="input input-bordered" required={field.required} />
                        {:else if field.type === 'file'}
                            <input id={field.id} type="file" class="file-input file-input-bordered" required={field.required} />
                        {/if}
                    </div>
                {/each}
                <div class="modal-action">
                    <button type="submit" class="btn btn-primary">Submit Request</button>
                    <button type="button" class="btn btn-ghost" onclick={closeForm}>Cancel</button>
                </div>
            </form>
        </div>
    </div>
{/if}