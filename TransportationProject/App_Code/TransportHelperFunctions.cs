using System;
using System.Web;
using System.Configuration;
using System.IO;
using System.Diagnostics;
using System.Text.RegularExpressions;

namespace TransportationProject
{
    public class TransportHelperFunctions
    {
        protected static String sql_connStr;

        //Need to keep synced with dbo.FileTypes table
        public enum uploadType
        {
            BOL,
            COFA,
            OTHER,
            IMAGE,
            PATTERN
        }

     

        [System.Web.Services.WebMethod]
        public static object convertStringEmptyToDBNULL(object strData)
        {
            // object rObj;

            //if (string.IsNullOrEmpty(strData) )
            if (object.ReferenceEquals(null, strData))
            {
                return (object)DBNull.Value;
            }
            else
            {
                if (string.IsNullOrEmpty(strData.ToString()))
                {
                    return (object)DBNull.Value;
                }
                else
                {
                    return strData;
                }

            }
        }

        public static String getTimestamp(DateTime value)
        {
            return value.ToString("yyyyMMddHHmmssffff");
        }

        public static string[] renameAndMoveFile(string filename, uploadType upT)
        {
            string[] pathObj = new string[2];
            string filepath = ConfigurationManager.AppSettings["fileUploadPath"];
            string newRootPath = ConfigurationManager.AppSettings["rootVirtualDirectoryUploadPath"];
            filepath = filepath.Replace("~/", string.Empty).Replace('/', '\\');
            filename = filename.Replace("~/", string.Empty).Replace('/', '\\');
            filename = Regex.Replace(filename.Trim(), "[^A-Za-z0-9_. ]+", ""); //remove special characters from filename;

            string newFilePathForFilemove = string.Empty;
            string newFilePathForDBEntry = string.Empty;
            string newFilePath = string.Empty;
            string newFilename = Path.GetFileNameWithoutExtension(filename) + getTimestamp(DateTime.UtcNow) + Path.GetExtension(filename);
            if (File.Exists(HttpRuntime.AppDomainAppPath + filepath + filename)) 
            //if (File.Exists(filepath + filename))
            {
                //TODO: CHANGE from using enum to grabbing filetypes using GetFileTypes() 
                switch (upT)
                {
                    case uploadType.BOL:
                        newFilePath = ConfigurationManager.AppSettings["BOLPath"];
                        break;
                    case uploadType.COFA:
                        newFilePath =  ConfigurationManager.AppSettings["COFAPath"];
                        break;
                    case uploadType.OTHER:
                        newFilePath = ConfigurationManager.AppSettings["OTHERPath"];
                        break;
                    case uploadType.IMAGE:
                        newFilePath = ConfigurationManager.AppSettings["IMAGEPATH"];
                        break;
                    case uploadType.PATTERN:
                        newFilePath = ConfigurationManager.AppSettings["PATTERNPATH"];
                        break;
                    default:
                        break;
                }
              

                newFilePathForFilemove = HttpContext.Current.Server.MapPath(newRootPath) + newFilePath;
                newFilePathForDBEntry = newRootPath + newFilePath;
  

                newFilePathForFilemove = newFilePathForFilemove.Replace("~/", "").Replace('/', '\\');
                newFilePathForDBEntry = newFilePathForDBEntry.Replace("~/", "").Replace('/', '\\');
                newFilename = newFilename.Replace("~/", "").Replace('/', '\\');

                //Move file from original location to physical location of virtual directorynewFilePathForFilemove
                File.Move(HttpRuntime.AppDomainAppPath + filepath + filename, newFilePathForFilemove + newFilename);

                //return path of virtualdirectory
                pathObj[0] = newFilePathForDBEntry;
                pathObj[1] = newFilename;
            }

            return pathObj;
        }

        [System.Web.Services.WebMethod]
        public static string[] ProcessFileAndData(string filename, string strUploadType)
        //public static string[] ProcessFileAndData(int MSID, string filename, string strUploadType)
        {

            ErrorLogging.WriteEvent("Starting fileupload", EventLogEntryType.Information);
            uploadType upT = (uploadType)Enum.Parse(typeof(uploadType), strUploadType);
            try
            {
                string[] newFileAndPath = renameAndMoveFile(filename, upT);
                if (2 == newFileAndPath.Length &&   ! string.IsNullOrWhiteSpace(newFileAndPath[0].ToString()))
                {
                    //TODO: ADD CODE FOR PROCESSING
                    return newFileAndPath;
                }
                else
                {
                    throw new Exception("renameAndMoveFile returned null or empty string");
                }
            }
            catch (Exception ex)
            {
                string strErr = " Exception Error in TransportHelperFunctions ProcessFileAndData(). Details: " + ex.ToString();
                ErrorLogging.WriteEvent(strErr, EventLogEntryType.Error);
                System.Web.HttpContext.Current.Session["ErrorNum"] = 1;
                ErrorLogging.sendtoErrorPage(1);
            }

            return null;
        }








    }
}