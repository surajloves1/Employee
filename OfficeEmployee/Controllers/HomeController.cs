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
using OfficeEmployee.Services;
using System.Web.Services.Description;

namespace OfficeEmployee.Controllers
{
    [InitializeSimpleMembership]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        [AllowAnonymous]

        public ActionResult Index(UserLogin.LoginModel model, string returnUrl)
        {
            //SendCalendar();
            int NumberOfLoggedInAttempts = 0;
            int currentUserId = WebSecurity.GetUserId(model.UserName);
            if (ModelState.IsValid)
            {
                if (currentUserId > 0)
                    NumberOfLoggedInAttempts = WebSecurity.GetPasswordFailuresSinceLastSuccess(model.UserName);

                if (NumberOfLoggedInAttempts >= 5)
                {
                    WebSecurity.Logout();
                    Session.Abandon();
                    return RedirectToAction("LockedOut", "Home");
                    //ModelState.AddModelError("", "You have been locked out. Please contact administrator to unlock you.");
                }
                else
                {
                    if (WebSecurity.Login(model.UserName, model.Password, persistCookie: true))
                    {

                        int loggedInUserId = WebSecurity.GetUserId(model.UserName);
                        Session["EMPLOYEENAME"] = model.UserName;

                        FormsAuthentication.SetAuthCookie(model.UserName, true);

                        if (Url.IsLocalUrl(returnUrl) && returnUrl.Length > 1 && returnUrl.StartsWith("/")
                            && !returnUrl.StartsWith("//") && !returnUrl.StartsWith("/\\"))
                        {
                            return Redirect(returnUrl);
                        }
                        else
                        {
                            return RedirectToAction("EmployeeList", "Employee");
                        }
                        
                    }
                    else
                    {
                        ModelState.AddModelError("", "The user name or password provided is incorrect.");
                    }
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult LogOff()
        {
            /*if (Request.QueryString["flogout"] == "1")
            {
                ViewModels.Security.FunctionLogin fLogin = new ViewModels.Security.FunctionLogin();
                fLogin.iEmployeeID = Convert.ToInt32(Session[ConstantValue.EMPLOYEEID]);
                fLogin.iFunctionID = Convert.ToInt32(Session[ConstantValue.LOGINFUNCTION]);
                fLogin.cLogType = "O";
                Models.Security.FunctionLoginRepository functionRepo = new Models.Security.FunctionLoginRepository();
                Boolean isAlreadyLoggedIn = functionRepo.IsEmployeeAlreadyLoggedIn(Convert.ToInt32(Session[ConstantValue.EMPLOYEEID]));
                if (isAlreadyLoggedIn)
                {
                    string duration = functionRepo.InsertData(fLogin);
                    //ViewBag.StartUpMessage = "FUNCTION LOGOUT SUCCESSFUL:  Duration – " + duration + " hrs";
                }
            }*/
            WebSecurity.Logout();
            Session.Abandon();
            return RedirectToAction("Index", "Home");
        }
    }
}