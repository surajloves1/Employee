using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations.Schema;
using System.Globalization;
using System.Web.Mvc;
using System.Web.Security;
using System.Data.Entity;
using OfficeEmployee.DatabaseEDMX;

public class EmployeeInformation
{
    public int UserId { get; set; }
    public string UserName { get; set; }
}
