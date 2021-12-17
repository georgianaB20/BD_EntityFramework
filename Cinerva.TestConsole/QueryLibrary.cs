using Cinerva.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Cinerva.TestConsole
{
    class QueryLibrary
    {
        private static CinervaDbContext DB { get; set; }
        static QueryLibrary()
        {
            DB = new CinervaDbContext();
        }

        //ex2
        public void GetAllPropertiesInCity(string city)
        {
            var propertiesInCity = DB.Properties
                .Where(p => p.City.Name == city)
                .Select(p => new { p.Name, p.Description, p.Address, p.TotalRooms })
                .ToList();

            foreach (var property in propertiesInCity)
            {
                Console.WriteLine($"{property.Name}\n{property.Description}\nAddress: {property.Address}\nTotalRooms: {property.TotalRooms}");
            }
        }

        //ex3
        public void GetAllClientsWithPayedReservations()
        {
            var clients = DB.Reservations
                .Where(r => r.PayedStatus == true)
                .Select(r => new { Name = $"{r.User.FirstName} {r.User.LastName}", r.User.Email, r.User.Phone })
                .ToList();

            foreach (var client in clients)
            {
                Console.WriteLine($"{client.Name}\n{client.Email}\n{client.Phone}\n");
            }
        }

        //ex4
        public void GetAllAdministratorsOfPropertyTypeInCity(string propertyType, string city)
        {
            var admins = DB.Properties
                .Where(p => p.City.Name == city && p.PropertyType.Type == propertyType)
                .Select(p => new { p.Administrator.FirstName, p.Administrator.LastName, p.Administrator.Id })
                .ToList();

            foreach (var admin in admins)
            {
                Console.WriteLine($"{admin.FirstName}\n{admin.LastName}\n{admin.Id}");
            }
        }
        //ex5
        public void GetAllRoomTypesAndPricesForNamedHotelInCountry(string hotelName, string country)
        {
            var ex5 = DB.Rooms
                .Where(r => r.Property.Name == hotelName && r.Property.City.Country.Name == country)
                .Select(r => new { r.RoomCategory.Name, r.RoomCategory.Price })
                .Distinct()
                .ToList();

            foreach (var res in ex5)
            {
                Console.WriteLine($"{res.Name} {res.Price}");
            }
        }
        //ex6
        public void GetTopXPropertiesInCountryByReservationCountInMonth(int x, string country, int month, int year)
        {
            if (month < 1 || month > 12) return;

            var november = new DateTime(2021, 11, 1);
            var december = new DateTime(2021, 12, 1);

            var properties = DB.Rooms.Include(r => r.Property)
                .Where(p => p.Property.City.Country.Name == "Romania"
                    && p.Reservations.Count(r => r.CheckInDate.Date >= november.Date && r.CheckInDate.Date <= december.Date) > 0)
                .GroupBy(p => p.PropertyId, p => p, (key, g) => new { Id = key, Reservations = g.Count() })
                //.GroupBy(r => r.Property.Name, r => r, (key, g) => new { Name = key, NrRes = g.ToList()})
                .OrderByDescending(g => g.Reservations)
                .Take(5)
                .ToList();

            foreach (var property in properties)
            {
                Console.WriteLine($"{property.Id} {property.Reservations}");
            }
        }

        //ex7
        public void GetHotelsWithPoolsAvailableToday()
        {
            var hotels = DB.Properties
                .Where(p => (p.PropertyType.Type == "Hotel"
                            && p.GeneralFeatures.Count(gf => gf.Name.Contains("Pool")) > 0)
                            && p.Rooms.Count(r => r.RoomReservations == null
                                                  || r.RoomReservations.Count(r => r.Reservation.CheckOutDate <= DateTime.Now.Date
                                                                                || r.Reservation.CheckInDate > DateTime.Now.Date
                                                                                || r.Reservation.CancelDate <= DateTime.Now.Date)
                                               > 0)
                         > 0)
                .Select(p => p.Name)
                .Distinct()
                .ToList();

            foreach (var hotel in hotels)
            {
                Console.WriteLine(hotel);
            }
        }

        //ex9
        public void GetHighestRatedPropertyWithFacilityAvailableNextWeekend(string facilityName)
        {
            var nextSunday = DateTime.Now.AddDays((double)(7 - DateTime.Now.DayOfWeek));
            var nextSaturday = nextSunday.AddDays(-1);

            var highestRatedPropertyWithSpaAvailableNextWeekend = DB.Rooms
                .Where(r =>
                    (r.Reservations.Count(re =>
                            re.CheckInDate.Date > nextSunday.Date
                            && re.CheckOutDate.Date < nextSaturday.Date
                            && re.CancelDate == null
                            || !(re.CheckInDate.Date > nextSunday.Date
                            && re.CheckOutDate.Date < nextSaturday.Date)
                            && re.CancelDate == null) > 0
                     || r.Reservations.Count() == 0)
                     && r.Property.GeneralFeatures.Count(gf => gf.Name == facilityName) > 0)
                .OrderBy(r => r.Property.Rating).AsEnumerable()
                .GroupBy(r => r.PropertyId)
                .Select(r => r.Key)
                .FirstOrDefault();

            Console.WriteLine(highestRatedPropertyWithSpaAvailableNextWeekend);
        }
        //ex10
        public void GetMostReservedMonthForHotel(int propertyId)
        {
            var mostReservedMonth = DB.RoomReservations
                .Where(rr => rr.Room.PropertyId == propertyId)
                .GroupBy(rr => rr.Reservation.CheckInDate.Month, rr => rr, (key, g) => new { Month = key, Reservations = g.ToList().Count() })
                .OrderByDescending(g => g.Month)
                .FirstOrDefault();

            Console.WriteLine(mostReservedMonth);
        }

        //ex11
        public void GetPropertiesWithAvailableRoomsForNextWeekendInCityBetweenPrice(int roomNumber, string roomCategory, string city, int minPrice, int maxPrice)
        {
            var monday = DateTime.Today.AddDays(-(int)DateTime.Today.DayOfWeek + (int)DayOfWeek.Monday);
            var sunday = monday.AddDays(7);

            var properties = DB.Properties
                .Where(p => p.City.Name == city
                            && p.Rooms.Count(r => r.RoomCategory.Name == roomCategory
                                                  && r.RoomCategory.Price >= minPrice
                                                  && r.RoomCategory.Price <= maxPrice
                                                  && r.Reservations.Count(re => re.CheckInDate.Date > monday.Date
                                                                                && re.CheckInDate.Date <= sunday.Date
                                                                                && re.CheckOutDate.Date > monday.Date
                                                                                && re.CheckOutDate.Date <= sunday) == 0

                                             ) >= roomNumber
                        )
                .GroupBy(p => p.Id, p => p, (key, g) => new { key = key, roomCat = g.Count() })
                .Where(g => g.roomCat >= roomNumber)
                .ToList();

            foreach (var prop in properties)
            {
                Console.WriteLine($"{prop.key} {prop.roomCat}");
            }
        }

        //ex12
        public void GetNumberOfGuestsWithBookingsInMonthAndCity(int month, int year, string city)
        {
            if (month < 1 || month > 12) return;

            var startOfMay = new DateTime(year, month, 1);
            var startOfJune = new DateTime(year, month + 1, 1);

            var properties = DB.RoomReservations.Include(rr => rr.Room).ThenInclude(r => r.Property)
                .Where(rr => rr.Room.Property.City.Name == city
                            && rr.Room.Property.PropertyType.Type == "Hotel"
                            && rr.Reservation.CheckInDate.Date >= startOfMay.Date
                            && rr.Reservation.CheckInDate.Date < startOfJune.Date)
                .Select(rr => new { User = rr.Reservation.User, Property = rr.Room.Property })
                .GroupBy(a => a.Property.Id, a => a, (key, g) => new { PropId = key, NrUsers = g.Distinct().Count() })
                .ToList();

            foreach (var property in properties)
            {
                Console.WriteLine($"{property.PropId} {property.NrUsers}");
            }
        }
    }
}
