-- Keep a log of any SQL queries you execute as you solve the mystery.

select description
from crime_scene_reports
where street like '%Humphrey%'and day = 28;
--getting information on what exactly happened that day.

select name,transcript
from interviews
where day = 28 and year = 2021 and month = 7;
--get information from the interviews done.

select account_number,amount
from atm_transactions
where day = 28 and month = 7 and year = 2021
and transaction_type = 'withdraw' and atm_location = 'Leggett Street';
--get who did an atm transaction following what Eugene said

--The flight ticket was purchased on the 28 and the thief travelled on the earliest flight the next day on the 29

select caller,receiver,duration
from phone_calls
where day = 28 and year = 2021 and month = 7 and duration < 60;
--get information on the phone call made during the theft

select person_id, creation_year, amount
from bank_accounts
join atm_transactions
on atm_transactions.account_number = bank_accounts.account_number
where atm_transactions.day = 28 and atm_transactions.month = 7
and atm_transactions.year = 2021 and atm_transactions.transaction_type = 'withdraw'
and atm_location = 'Leggett Street';
--get the link between the atm transaction done by the thief according to Eugene and the bank account linked to it

select name,passport_number,license_plate,duration
from people
join phone_calls
on phone_calls.caller = people.phone_number or phone_calls.receiver = people.phone_number
where  phone_calls.day = 28 and phone_calls.year = 2021
and phone_calls.month = 7 and phone_calls.duration < 60;
--get the names of those who called or received a call that day based on the previous informations

select distinct name as caller, passport_number, license_plate
from people
join phone_calls
on phone_calls.caller = people.phone_number
where  phone_calls.day = 28 and phone_calls.year = 2021
and phone_calls.month = 7 and phone_calls.duration < 60;
--get the list of possible phone callers during the theft

select distinct name as receiver, passport_number, license_plate
from people
join phone_calls
on phone_calls.receiver = people.phone_number
where  phone_calls.day = 28 and phone_calls.year = 2021
and phone_calls.month = 7 and phone_calls.duration < 60;
--get the list of possible phone receivers during the theft

select *
from passengers
where passengers.passport_number = (
    select passport_number
    from people
    join phone_calls
    on phone_calls.caller = people.phone_number
    where  phone_calls.day = 28 and phone_calls.year = 2021
    and phone_calls.month = 7 and phone_calls.duration < 60);
    --get the passenger who called amongst the possible callers we have

select *
from passengers
where passengers.passport_number = (
    select passport_number
    from people join phone_calls
    on phone_calls.receiver = people.phone_number
    where  phone_calls.day = 28 and phone_calls.year = 2021
    and phone_calls.month = 7 and phone_calls.duration < 60);
    --get the passenger who received the call amongst the possible receivers we have

select name AS Culprit,phone_number,passport_number,license_plate
from people
where passport_number = (
    select passport_number
    from passengers
    where passengers.passport_number = (
        select passport_number
        from people
        join phone_calls
        on phone_calls.caller = people.phone_number
        where  phone_calls.day = 28 and phone_calls.year = 2021
        and phone_calls.month = 7 and phone_calls.duration < 60));
        --get the passenger who called during the robbery

select name AS Culprit,phone_number,passport_number,license_plate
from people
where passport_number = (
    select passport_number
    from passengers
    where passengers.passport_number = (
        select passport_number
        from people
        join phone_calls
        on phone_calls.receiver = people.phone_number
        where  phone_calls.day = 28 and phone_calls.year = 2021
        and phone_calls.month = 7 and phone_calls.duration < 60));
        --get the passenger who received the call during the robbery


select hour,minute,activity
from bakery_security_logs
where license_plate = (
    select license_plate
    from people
    where passport_number = (
        select passport_number
        from passengers
        where passengers.passport_number = (
            select passport_number
            from people
            join phone_calls
            on phone_calls.caller = people.phone_number
            where  phone_calls.day = 28 and phone_calls.year = 2021
            and phone_calls.month = 7 and phone_calls.duration < 60)));
            --this shows that Sophia is involved and was the driver

select destination_airport_id, day, hour, minute, abbreviation, full_name
from flights
join airports on flights.destination_airport_id = airports.id
where origin_airport_id = 8 and day = 29
order by destination_airport_id;
--get the first flight ofthe next day of the robbery
