import {
	ClipboardText,
	Scroll,
	FileText,
	CurrencyCircleDollar,
	CalendarPlus,
	UserCircle,
	AddressBook,
	Handshake
} from 'phosphor-svelte';

export interface RequestType {
	id: string;
	category: 'Academic' | 'Financial' | 'Administrative' | 'IT' | 'Other';
	icon: any; // Use specific icon type from Phosphor Svelte if possible
	title: string;
	description: string;
	/**
	 * The key of the form to use for this request type.
	 * This key should match a key in the `requestForms` record.
	 * If undefined, the request type does not have a specific form.
	 */
	formKey?: string;
}

export interface RequestFormField {
	id: string;
	label: string;
	type: 'text' | 'textarea' | 'select' | 'date' | 'file' | 'number';
	required: boolean;
	options?: string[]; // For select type
	placeholder?: string;
}

export interface RequestForm {
	[key: string]: RequestFormField[];
}

class RequestsStore {
	requestTypes = $state<RequestType[]>([
		{
			id: 'transcript-request',
			category: 'Academic',
			icon: ClipboardText,
			title: 'Transcript Request',
			description: 'Order an official transcript of your academic record.',
			formKey: 'transcript'
		},
		{
			id: 'enrollment-verification',
			category: 'Academic',
			icon: Scroll,
			title: 'Enrollment Verification',
			description: 'Request a document verifying your enrollment status.',
			formKey: 'enrollment'
		},
		{
			id: 'payment-reference',
			category: 'Financial',
			icon: CurrencyCircleDollar,
			title: 'Payment Reference',
			description: 'Generate a payment reference for tuition or other fees.'
		},
		{
			id: 'scholarship-application',
			category: 'Financial',
			icon: UserCircle,
			title: 'Scholarship Application',
			description: 'Apply for available scholarships and financial aid.',
			formKey: 'scholarship'
		},
		{
			id: 'course-registration',
			category: 'Academic',
			icon: CalendarPlus,
			title: 'Course Registration',
			description: 'Register for courses for the upcoming semester.',
			formKey: 'course'
		},
		{
			id: 'it-support',
			category: 'IT',
			icon: AddressBook,
			title: 'IT Support Request',
			description: 'Submit a request for technical assistance or support.',
			formKey: 'itSupport'
		},
		{
			id: 'student-card',
			category: 'Administrative',
			icon: FileText,
			title: 'Student Card Replacement',
			description: 'Request a replacement for a lost or damaged student ID card.',
			formKey: 'studentCard'
		},
		{
			id: 'advisor-meeting',
			category: 'Academic',
			icon: Handshake,
			title: 'Advisor Meeting Request',
			description: 'Schedule a meeting with your academic advisor.',
			formKey: 'advisorMeeting'
		},
	]);

	requestForms = $state<RequestForm>({
		transcript: [
			{ id: 'studentId', label: 'Student ID', type: 'text', required: true, placeholder: 'Enter your student ID' },
			{ id: 'name', label: 'Full Name', type: 'text', required: true, placeholder: 'Enter your full name' },
			{
				id: 'deliveryMethod',
				label: 'Delivery Method',
				type: 'select',
				required: true,
				options: ['Mail', 'Email', 'In-Person Pickup']
			},
			{ id: 'address', label: 'Address', type: 'textarea', required: false, placeholder: 'Enter address if applicable' }
		],
		enrollment: [
			{ id: 'studentId', label: 'Student ID', type: 'text', required: true, placeholder: 'Enter your student ID' },
			{ id: 'name', label: 'Full Name', type: 'text', required: true, placeholder: 'Enter your full name' },
			{ id: 'program', label: 'Program', type: 'text', required: true, placeholder: 'Enter your program of study' },
			{ id: 'purpose', label: 'Purpose of Verification', type: 'textarea', required: true, placeholder: 'Enter the purpose of verification' }
		],
		scholarship: [
			{ id: 'studentId', label: 'Student ID', type: 'text', required: true, placeholder: 'Enter your student ID' },
			{ id: 'name', label: 'Full Name', type: 'text', required: true, placeholder: 'Enter your full name' },
			{ id: 'gpa', label: 'GPA', type: 'number', required: true, placeholder: 'Enter your current GPA' },
			{ id: 'essay', label: 'Personal Statement', type: 'textarea', required: true, placeholder: 'Describe your eligibility for the scholarship' }
		],
		itSupport: [
			{ id: 'name', label: 'Your Name', type: 'text', required: true, placeholder: 'Enter your name' },
			{ id: 'email', label: 'Email', type: 'text', required: true, placeholder: 'Enter your email' },
			{
				id: 'issueType',
				label: 'Type of Issue',
				type: 'select',
				required: true,
				options: ['Hardware', 'Software', 'Network', 'Account', 'Other']
			},
			{ id: 'description', label: 'Description of Issue', type: 'textarea', required: true, placeholder: 'Describe the issue you are experiencing' }
		],
		studentCard: [
			{ id: 'studentId', label: 'Student ID', type: 'text', required: true, placeholder: 'Enter your student ID' },
			{ id: 'name', label: 'Full Name', type: 'text', required: true, placeholder: 'Enter your full name' },
			{ id: 'reason', label: 'Reason for Replacement', type: 'textarea', required: true, placeholder: 'Explain why you need a new card' }
		],
		course: [
			{ id: 'studentId', label: 'Student ID', type: 'text', required: true, placeholder: 'Enter your student ID' },
			{ id: 'name', label: 'Full Name', type: 'text', required: true, placeholder: 'Enter your full name' },
			{ id: 'courseCode', label: 'Course Code', type: 'text', required: true, placeholder: 'Enter the course code' },
			{ id: 'courseName', label: 'Course Name', type: 'text', required: true, placeholder: 'Enter the course name' },
			{
				id: 'semester',
				label: 'Semester',
				type: 'select',
				required: true,
				options: ['Fall', 'Winter', 'Summer', 'Spring']
			}
		],
		advisorMeeting: [
			{ id: 'studentId', label: 'Student ID', type: 'text', required: true, placeholder: 'Enter your student ID' },
			{ id: 'name', label: 'Full Name', type: 'text', required: true, placeholder: 'Enter your full name' },
			{ id: 'advisorName', label: 'Advisor Name', type: 'text', required: true, placeholder: 'Enter your advisor\'s name' },
			{ id: 'meetingReason', label: 'Reason for Meeting', type: 'textarea', required: true, placeholder: 'Describe the purpose of the meeting' }
		]
	});

	getRequestTypes = () => this.requestTypes;

	getRequestForm = (formKey: string) => this.requestForms[formKey];
}

export const requestsStore = new RequestsStore();

