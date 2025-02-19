-- 06_library_tables.sql
-- Sets up the database structure for managing library resources, including books, authors, publishers, and loans.

-- Author: Stores information about book authors
CREATE TABLE library.author (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL
);

COMMENT ON COLUMN library.author.id IS 'Unique identifier for the author';
COMMENT ON COLUMN library.author.name IS 'Full name of the author';

-- Publisher: Contains details about book publishers
CREATE TABLE library.publisher (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL
);

COMMENT ON COLUMN library.publisher.id IS 'Unique identifier for the publisher';
COMMENT ON COLUMN library.publisher.name IS 'Name of the publishing company';

CREATE INDEX idx_publisher_name ON library.publisher(name);

-- Book: Stores essential information about books
CREATE TABLE library.book (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    publisher_id UUID REFERENCES library.publisher(id),
    isbn VARCHAR(13),
    publication_year INT
);

COMMENT ON COLUMN library.book.id IS 'Unique identifier for the book';
COMMENT ON COLUMN library.book.title IS 'Title of the book';
COMMENT ON COLUMN library.book.publisher_id IS 'Reference to the book''s publisher';
COMMENT ON COLUMN library.book.isbn IS 'International Standard Book Number (13 digits)';
COMMENT ON COLUMN library.book.publication_year IS 'Year the book was published';

CREATE INDEX idx_book_title ON library.book(title);
CREATE INDEX idx_book_isbn ON library.book(isbn);
CREATE INDEX idx_book_publisher ON library.book(publisher_id);

-- Book_Author: Maps the relationship between books and authors
CREATE TABLE library.book_author (
    book_id UUID REFERENCES library.book(id),
    author_id UUID REFERENCES library.author(id),
    PRIMARY KEY (book_id, author_id)
);

COMMENT ON COLUMN library.book_author.book_id IS 'Reference to the book';
COMMENT ON COLUMN library.book_author.author_id IS 'Reference to the author';

CREATE INDEX idx_book_author_book ON library.book_author(book_id);
CREATE INDEX idx_book_author_author ON library.book_author(author_id);

-- Book_Topic: Maps books to their corresponding topics
-- Update the book_topic table in the library schema
DROP TABLE IF EXISTS library.book_topic;

CREATE TABLE library.book_topic (
    book_id UUID REFERENCES library.book(id),
    topic_id UUID REFERENCES agnostic.topic(id),
    PRIMARY KEY (book_id, topic_id)
);

COMMENT ON COLUMN library.book_topic.book_id IS 'Reference to the book';
COMMENT ON COLUMN library.book_topic.topic_id IS 'Reference to the topic from the agnostic schema';

CREATE INDEX idx_book_topic_book ON library.book_topic(book_id);
CREATE INDEX idx_book_topic_topic ON library.book_topic(topic_id);

-- Book_Copy: Represents physical copies of books in library facilities
CREATE TABLE library.book_copy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    book_id UUID NOT NULL REFERENCES library.book(id),
    library_facility_id UUID NOT NULL,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_library_facility FOREIGN KEY (library_facility_id)
        REFERENCES infrastruct.facility(id)
);

COMMENT ON COLUMN library.book_copy.id IS 'Unique identifier for the book copy';
COMMENT ON COLUMN library.book_copy.book_id IS 'Reference to the book';
COMMENT ON COLUMN library.book_copy.library_facility_id IS 'Reference to the library facility where the copy is located';
COMMENT ON COLUMN library.book_copy.status IS 'Current status of the book copy (e.g., available, loaned, maintenance)';

CREATE INDEX idx_book_copy_book ON library.book_copy(book_id);
CREATE INDEX idx_book_copy_library_facility ON library.book_copy(library_facility_id);
CREATE INDEX idx_book_copy_status ON library.book_copy(status);

-- Function to ensure book copies are only associated with library facilities
CREATE OR REPLACE FUNCTION library.check_library_facility()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM infrastruct.facility
        WHERE id = NEW.library_facility_id AND facility_type = 'library'
    ) THEN
        RAISE EXCEPTION 'The specified facility (%) is not a library', NEW.library_facility_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to enforce the library facility check
CREATE TRIGGER enforce_library_facility
BEFORE INSERT OR UPDATE ON library.book_copy
FOR EACH ROW EXECUTE FUNCTION library.check_library_facility();

-- Loan: Tracks book loans to students
CREATE TABLE library.loan (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES student.student(id),
    book_copy_id UUID NOT NULL REFERENCES library.book_copy(id),
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE
);

COMMENT ON COLUMN library.loan.id IS 'Unique identifier for the loan';
COMMENT ON COLUMN library.loan.student_id IS 'Reference to the student who borrowed the book';
COMMENT ON COLUMN library.loan.book_copy_id IS 'Reference to the specific book copy that was loaned';
COMMENT ON COLUMN library.loan.loan_date IS 'Date when the book was loaned';
COMMENT ON COLUMN library.loan.due_date IS 'Date by which the book should be returned';
COMMENT ON COLUMN library.loan.return_date IS 'Actual date when the book was returned (null if not yet returned)';

CREATE INDEX idx_loan_student ON library.loan(student_id);
CREATE INDEX idx_loan_book_copy ON library.loan(book_copy_id);
CREATE INDEX idx_loan_dates ON library.loan(loan_date, due_date, return_date);