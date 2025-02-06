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


namespace OfficeEmployee.Models
{
    public class UsersContext : DbContext
    {
        public UsersContext()
            : base("DefaultConnection")
        {
        }
        public DbSet<UserProfile> UserProfiles { get; set; }
    }
    [Table("UserProfile")]
    public class UserProfile
    {
        [Key]
        [DatabaseGeneratedAttribute(DatabaseGeneratedOption.Identity)]
        public int UserId { get; set; }
        public string UserName { get; set; }
    }
    public class UserLogin
    {
        public class LoginModel
        {
            
            [Display(Name = "User name")]
            [Required(ErrorMessage = "Required")]
            public string UserName { get; set; }

            [Required(ErrorMessage = "Required")]
            [DataType(DataType.Password)]
            [Display(Name = "Password")]
            public string Password { get; set; }

        }
    }
}