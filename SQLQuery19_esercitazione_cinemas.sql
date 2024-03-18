DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Showtime;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Theater;
DROP TABLE IF EXISTS Cinema;

CREATE TABLE Cinema (
CinemaID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
Address VARCHAR(255) NOT NULL,
Phone VARCHAR(20)
);
CREATE TABLE Theater (
TheaterID INT PRIMARY KEY,
CinemaID INT,
Name VARCHAR(50) NOT NULL,
Capacity INT NOT NULL,
ScreenType VARCHAR(50),
FOREIGN KEY (CinemaID) REFERENCES Cinema(CinemaID)
);
CREATE TABLE Movie (
MovieID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
Director VARCHAR(100),
ReleaseDate DATE,
DurationMinutes INT,
Rating VARCHAR(5)
);
CREATE TABLE Showtime (
ShowtimeID INT PRIMARY KEY,
MovieID INT,
TheaterID INT,
ShowDateTime DATETIME NOT NULL,
Price DECIMAL(5,2) NOT NULL,
FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
FOREIGN KEY (TheaterID) REFERENCES Theater(TheaterID)
);

CREATE TABLE Customer (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100),
PhoneNumber VARCHAR(20)
);

CREATE TABLE Ticket (
TicketID INT PRIMARY KEY,
ShowtimeID INT,
SeatNumber VARCHAR(10) NOT NULL,
PurchasedDateTime DATETIME NOT NULL,
CustomerID INT,
FOREIGN KEY (ShowtimeID) REFERENCES Showtime(ShowtimeID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Review (
ReviewID INT PRIMARY KEY,
MovieID INT,
CustomerID INT,
ReviewText TEXT,
Rating INT CHECK (Rating >= 1 AND Rating <= 5),
ReviewDate DATETIME NOT NULL,
FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE Employee (
EmployeeID INT PRIMARY KEY,
CinemaID INT,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Position VARCHAR(50),
HireDate DATE,
FOREIGN KEY (CinemaID) REFERENCES Cinema(CinemaID)
);


INSERT INTO Cinema (CinemaID, Name, Address, Phone) VALUES
(1, 'Star Cineplex', '123 Movie Blvd, Hollywood, CA', '555-1234'),
(2, 'Cinema Paradiso', '456 Cinema St, Rome, Italy', '555-5678'),
(3, 'Grand Theater', '789 Broadway Ave, New York, NY', '555-2468');


INSERT INTO Theater (TheaterID, CinemaID, Name, Capacity, ScreenType) VALUES
(1, 1, 'Theater 1', 150, 'IMAX'),
(2, 1, 'Theater 2', 200, 'Standard'),
(3, 2, 'Sala 1', 120, '3D'),
(4, 3, 'Auditorium A', 300, 'IMAX');


INSERT INTO Movie (MovieID, Title, Director, ReleaseDate, DurationMinutes, Rating) VALUES
(1, 'The Great Adventure', 'John Doe', '2023-07-15', 120, 'PG'),
(2, 'Love in the Time of AI', 'Jane Smith', '2023-08-01', 135, 'R'),
(3, 'Mystery of the Lost City', 'Alice Johnson', '2023-09-20', 115, 'PG-13');


INSERT INTO Showtime (ShowtimeID, MovieID, TheaterID, ShowDateTime, Price) VALUES
(1, 1, 1, CONVERT(datetime, '2024-03-15 18:00:00', 120), 12.50),
(2, 2, 3, CONVERT(datetime, '2024-03-15 19:00:00', 120), 11.00),
(3, 3, 4, CONVERT(datetime, '2024-03-15 20:00:00', 120), 10.00),
(4, 1, 2, CONVERT(datetime, '2024-03-15 21:00:00', 120), 9.50),
(5, 2, 3, CONVERT(datetime, '2024-03-15 22:00:00', 120), 11.50),
(6, 3, 4, CONVERT(datetime, '2024-03-15 23:00:00', 120), 10.50);



INSERT INTO Customer (CustomerID, FirstName, LastName, Email, PhoneNumber) VALUES
(1, 'Alice', 'Wonderland', 'alice@example.com', '555-0101'),
(2, 'Bob', 'Builder', 'bob@example.com', '555-0202'),
(3, 'Charlie', 'Chocolate', 'charlie@example.com', '555-0303');


INSERT INTO Ticket (TicketID, ShowtimeID, SeatNumber, PurchasedDateTime, CustomerID) VALUES
(1, 1, 'A1', CONVERT(datetime, '2023-07-10 10:00:00', 120), 1),
(2, 2, 'B5', CONVERT(datetime, '2023-07-20 11:30:00', 120), 2),
(3, 3, 'C10',CONVERT(datetime, '2023-08-01 15:45:00', 120), 3);


INSERT INTO Review (ReviewID, MovieID, CustomerID, ReviewText, Rating, ReviewDate) VALUES
(1, 1, 1, 'Absolutely loved it! A must-watch.', 5, CONVERT(datetime, '2023-07-16 20:00:00', 120)),
(2, 2, 2, 'Great movie but a bit too long for my taste.', 4, CONVERT(datetime, '2023-08-03 22:00:00', 120)),
(3, 3, 3, 'Intriguing plot but the ending was predictable.', 3, CONVERT(datetime, '2023-09-22 23:00:00', 120));


INSERT INTO Employee (EmployeeID, CinemaID, FirstName, LastName, Position, HireDate) VALUES
(1, 1, 'Dave', 'Manager', 'Manager', '2020-01-01'),
(2, 2, 'Eva', 'Smith', 'Ticket Seller', '2021-05-15'),
(3, 3, 'Frank', 'Ocean', 'Cleaner', '2022-07-01');


/*
 * Creare una vista FilmsInProgrammation che mostri i titoli dei film, la data di inizio
 * programmazione, la durata e la classificazione per età [suggerimento - rating al posto di classificazione per eta]. 
 * Questa vista aiuterà il personale e i clienti a vedere rapidamente quali film sono attualmente in programmazione.
 */
CREATE VIEW FilmsInProgrammation AS
	SELECT Movie.title AS 'title', Movie.ReleaseDate AS 'start date', Movie.DurationMinutes 'duration', Movie.Rating 'rating' 
	FROM Movie
	
SELECT * FROM FilmsInProgrammation

------------------------------------------------------------------------

/*
 * Creare una vista AvailableSeatsForShow che, per ogni spettacolo, mostri il numero totale di
 * posti nella sala e quanti sono ancora disponibili. Questa vista è essenziale per il personale alla
 * biglietteria per gestire le vendite dei biglietti.
 */
--SP he analizza ogni riga e può manipolarla

CREATE VIEW AvailableSeatsForShow AS
	SELECT Theater.Capacity AS 'full capacity', (Theater.Capacity - COUNT(Ticket.TicketID)) AS 'live capacity'
	FROM Showtime
	JOIN Ticket ON Showtime.ShowtimeID = Ticket.ShowtimeID
	JOIN Theater ON Ticket.TicketID = Theater.TheaterID
	GROUP BY Theater.Capacity

SELECT * FROM AvailableSeatsForShow;

------------------------------------------------------------------------

/*
 * Generare una vista TotalEarningsPerMovie che elenchi ogni film insieme agli incassi totali
 * generati. Questa informazione è cruciale per la direzione per valutare il successo commerciale dei
 * film.
 */

CREATE VIEW TotalEarningsPerMovie AS
	SELECT Title, SUM(Price) AS 'Total Price'
	FROM Movie
	JOIN Showtime ON Movie.MovieID = Showtime.MovieID
	JOIN Ticket ON Showtime.ShowtimeID = Ticket.ShowtimeID
	GROUP BY Movie.Title

SELECT * FROM TotalEarningsPerMovie;

------------------------------------------------------------------------

/*
 * Creare una vista RecentReviews che mostri le ultime recensioni lasciate dai clienti, includendo il
 * titolo del film, la valutazione, il testo della recensione e la data. Questo permetterà al personale e
 * alla direzione di monitorare il feedback dei clienti in tempo reale.
 */
 
CREATE VIEW RecentReviews AS
	SELECT Review.ReviewText AS 'Reviews Text', Movie.Title AS 'Title', Review.Rating AS 'Rating', Review.ReviewDate AS 'Date'
	FROM Review
	JOIN Movie ON Review.MovieID = Movie.MovieID
	ORDER BY Review.ReviewDate DESC

SELECT * FROM RecentReviews

------------------------------------------------------------------

/*
 * Creare una stored procedure PurchaseTicket che permetta di acquistare un biglietto per uno
 * spettacolo, specificando l'ID dello spettacolo, il numero del posto e l'ID del cliente. La procedura
 * dovrebbe verificare la disponibilità del posto e registrare l'acquisto.
 */
DROP PROCEDURE IF EXISTS PurchaseTicket;
CREATE PROCEDURE PurchaseTicket
    @ShowtimeID INT,
    @SeatNumber VARCHAR(10),
    @CustomerID INT,
    @PurchasedDateTime DATETIME
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @count INT;
            SELECT @count = COUNT(*)
            FROM Ticket
            WHERE ShowtimeID = @ShowtimeID AND SeatNumber = @SeatNumber;
            
            IF NOT EXISTS (SELECT 1 FROM Showtime WHERE ShowtimeID = @ShowtimeID)
            BEGIN
                THROW 50002, 'errore: lo spettacolo non esiste', 1;
            END
            
            PRINT '@count: ' + CAST(@count AS VARCHAR);	
            IF @count = 0
            BEGIN
                INSERT INTO Ticket (ShowtimeID, SeatNumber, PurchasedDateTime, CustomerID)
                VALUES (@ShowtimeID, @SeatNumber, @PurchasedDateTime, @CustomerID);
                PRINT 'biglietto acquistato';
            END
            ELSE
            BEGIN
                THROW 50002, 'biglietto non esistente', 1;
            END
            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'errore ' + ERROR_MESSAGE();
    END CATCH
END;

EXEC PurchaseTicket 
	@ShowtimeID = 1, 
	@SeatNumber = 'D1', 
	@CustomerID = 1, 
	@PurchasedDateTime = '2024-03-20T14:00:00';

EXEC PurchaseTicket 
	@ShowtimeID = 1, 
	@SeatNumber = 'A1', 
	@CustomerID = 2, 
	@PurchasedDateTime = '2024-03-20T15:00:00';

EXEC PurchaseTicket 
	@ShowtimeID = 2, 
	@SeatNumber = 'B2', 
	@CustomerID = 1, 
	@PurchasedDateTime = '2024-03-21T16:00:00';

EXEC PurchaseTicket 
	@ShowtimeID = 3, 
	@SeatNumber = 'C3', 
	@CustomerID = 3, 
	@PurchasedDateTime = '2024-03-22T17:00:00';

------------------------------------------------------------------------

/*
 * Implementare una stored procedure UpdateMovieSchedule che permetta di aggiornare gli orari
 * degli spettacoli per un determinato film. Questo include la possibilità di aggiungere o rimuovere
 * spettacoli dall'agenda.
 */
DROP PROCEDURE IF EXISTS UpdateMovieSchedule;
CREATE PROCEDURE UpdateMovieSchedule
    @ShowtimeID INT = NULL,
    @MovieID INT = NULL,
    @TheaterID INT = NULL,
    @ShowDateTime DATETIME = NULL,
    @Price DECIMAL(5,2) = NULL,
    @comando NVARCHAR(10)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF @comando = 'aggiungi'
        BEGIN
            DECLARE @NextShowtimeID INT = 1;

            WHILE EXISTS (SELECT * FROM Showtime WHERE ShowtimeID = @NextShowtimeID)
            BEGIN
                SET @NextShowtimeID = @NextShowtimeID + 1;
            END
            
            IF NOT EXISTS (SELECT * FROM Showtime
                           WHERE MovieID = @MovieID AND TheaterID = @TheaterID
                           AND ShowDateTime = @ShowDateTime)
            BEGIN
                INSERT INTO Showtime (ShowtimeID, MovieID, TheaterID, ShowDateTime, Price)
                VALUES (@NextShowtimeID, @MovieID, @TheaterID, @ShowDateTime, @Price)    
                PRINT 'spettacolo aggiunto';
            END
            ELSE
            BEGIN
                PRINT 'spettacolo esistente';
            END
        END
        ELSE IF @comando = 'rimuovi'
		BEGIN
			IF EXISTS (SELECT * FROM Showtime WHERE ShowtimeID = @ShowtimeID)
			BEGIN
				DELETE FROM Ticket WHERE ShowtimeID = @ShowtimeID;
				DELETE FROM Showtime WHERE ShowtimeID = @ShowtimeID;
				PRINT 'spettacolo rimosso';
			END
			ELSE
			BEGIN
				PRINT 'spettacolo non trovato';
			END
		END

        ELSE
        BEGIN
            THROW 50002, 'comando sbagliato', 1;
        END
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'errore : ' + ERROR_MESSAGE();
    END CATCH
END;

EXEC UpdateMovieSchedule 
	@MovieID = 1, 
	@TheaterID = 1, 
	@ShowDateTime = '2024-04-01T20:00:00', 
	@Price = 12.50, 
	@comando = 'aggiungi';

EXEC UpdateMovieSchedule 
	@ShowtimeID = 1, 
	@comando = 'rimuovi';

------------------------------------------------------------------------

/*
 * Sviluppare una stored procedure InsertNewMovie che consenta di inserire un nuovo film nel
 * sistema, richiedendo tutti i dettagli pertinenti come titolo, regista, data di uscita, durata e
 * classificazione.
 */
DROP PROCEDURE IF EXISTS InsertNewMovie;
CREATE PROCEDURE InsertNewMovie
    @Title NVARCHAR(255),
    @Director NVARCHAR(100),
    @ReleaseDate DATE,
    @DurationMinutes INT,
    @Rating NVARCHAR(5)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
			DECLARE @NewMovieID INT = 1;
			WHILE EXISTS (SELECT * FROM Movie WHERE MovieID = @NewMovieID)
			BEGIN
				SET @NewMovieID = @NewMovieID + 1;
			END
			INSERT INTO Movie (MovieID, Title, Director, ReleaseDate, DurationMinutes, Rating)
			VALUES (@NewMovieID, @Title, @Director, @ReleaseDate, @DurationMinutes, @Rating);
        COMMIT TRANSACTION
        PRINT 'film inserito';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'errore :' + ERROR_MESSAGE();
    END CATCH
END;

EXEC InsertNewMovie
    @Title = 'Un posto al sale',
    @Director = 'Antonio Oinotna',
    @ReleaseDate = '2021-12-12',
    @DurationMinutes = 450,
    @Rating = 'PG-13';


------------------------------------------------------------------------

/*
 * Creare una stored procedure SubmitReview che consenta ai clienti di lasciare una recensione per
 * un film, comprensiva di valutazione, testo e data. Questa procedura dovrebbe verificare che il
 * cliente abbia effettivamente acquistato un biglietto per il film in questione prima di permettere la
 * pubblicazione della recensione.
 */

DROP PROCEDURE IF EXISTS SubmitReview;
CREATE PROCEDURE SubmitReview
    @CustomerID INT,
    @MovieID INT,
    @ReviewText TEXT,
    @Rating INT,
    @ReviewDate DATETIME
AS
BEGIN
    BEGIN TRY
        IF EXISTS (
            SELECT 1
            FROM Ticket
            JOIN Showtime ON Ticket.ShowtimeID = Showtime.ShowtimeID
            WHERE Ticket.CustomerID = @CustomerID 
            AND Showtime.MovieID = @MovieID
            AND Showtime.ShowDateTime <= GETDATE()
        )
        BEGIN
            DECLARE @NewReviewID INT = 1;
            WHILE EXISTS (SELECT 1 FROM Review WHERE ReviewID = @NewReviewID)
            BEGIN
                SET @NewReviewID = @NewReviewID + 1;
            END

            INSERT INTO Review (ReviewID, MovieID, CustomerID, ReviewText, Rating, ReviewDate)
            VALUES (@NewReviewID, @MovieID, @CustomerID, @ReviewText, @Rating, @ReviewDate);   
            PRINT 'recensione registrata';
        END
        ELSE
        BEGIN
            PRINT 'il film non è stato ancora visto dal cliente e/o non ha ancora acquistato il biglietto.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'errore :' + ERROR_MESSAGE();
    END CATCH
END;

EXEC SubmitReview 
    @CustomerID = 3, 
    @MovieID = 3, 
    @ReviewText = 'bello dai', 
    @Rating = 3, 
    @ReviewDate = '2024-03-18T15:00:00';

EXEC SubmitReview 
    @CustomerID = 1, 
    @MovieID = 3, 
    @ReviewText = 'non l''ho visto', 
    @Rating = 5, 
    @ReviewDate = '2024-03-19T15:00:00';


	