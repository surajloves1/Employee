using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.Routing;
using OfficeEmployee.DatabaseEDMX;
using WebMatrix.WebData;
using OfficeEmployee.Models;
namespace OfficeEmployee.Controllers
{
    [InitializeSimpleMembership]
    public class EmployeeController : Controller
    {
        public ActionResult EmployeeList()
        {
            OfficeEmployee.Services.EmployeeList empList = new OfficeEmployee.Services.EmployeeList();
            //return PartialView("Employee/_EmployeeList", empList.GetUserList()); // Removing Comments
            return View(empList.GetUserList());
        }
    }
}