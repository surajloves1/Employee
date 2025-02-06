using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Threading.Tasks;
using OfficeEmployeeModel;
namespace OfficeEmployee.Services
{
    public class EmployeeList
    {
        public IEnumerable<Detail_Employee> GetUserList()
        {
            using (var context = new employeeEntities())
            {
                return context.Detail_Employee.Where(x=>x.cEmployeeStatus=="A").OrderBy(x => x.vEmployeeName).ToList();
            }
        }
    }
}