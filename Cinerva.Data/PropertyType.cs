using System.Collections.Generic;

namespace Cinerva.Data
{
    public class PropertyType
    {
        public int Id { get; set; }
        public string Type { get; set; }
        public IList<Property> Properties { get; set; }
    }
}
