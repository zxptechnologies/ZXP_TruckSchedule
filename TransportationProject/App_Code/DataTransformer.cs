using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.Xml;
using System.Web;

namespace TransportationProject
{
    public class DataTransformer
    {

        public DataTransformer()
        { }


        public static string PasswordHash(string ClearTextPassword)
        {
            return DataTransformer.getMD5Hash(ClearTextPassword); //Can modify to different type of hashing  
        }

        private static string getMD5Hash(string INPUT)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.UTF8.GetBytes(INPUT));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            return sBuilder.ToString();
        }

      


        public static string createSHA256HashedString(string originalString)
        {
            SHA256 SHA256Hasher = System.Security.Cryptography.SHA256.Create();

            Byte[] data = SHA256Hasher.ComputeHash(Encoding.Default.GetBytes(originalString));

            StringBuilder sBuilder = new System.Text.StringBuilder();

            int i;

            for (i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            return sBuilder.ToString();
        }


        public static string createXML(string rootname, string childname, IEnumerable<string> childElements)
        {
            if (!string.IsNullOrEmpty(rootname) && !string.IsNullOrEmpty(childname))
            {
                XmlDocument xml = new XmlDocument();
                XmlElement root = xml.CreateElement(rootname);
                xml.AppendChild(root);

                foreach (string ce in childElements)
                {
                    XmlElement child = xml.CreateElement(childname);
                    child.InnerText = ce;
                    root.AppendChild(child);
                }

                return xml.OuterXml;
            }
            return string.Empty;
        }

    }
}