using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.IO.Ports;

namespace TransportationProject
{

    public class SerialDataCommunication
    {
        
        static readonly byte bSTART = 2 ;
        static readonly byte[] baEND = new byte[] {13, 10};
        static readonly byte[] baPRINT = new byte[] {80,13};
        public string serialportName { get; set; }
        public int baudrate { get; set; }
        public string parityStr { get; set; }
        public int sdata { get; set; }
        public string stopBitsStr { get; set; }
        private SerialPort sPort;
        public StringBuilder spBuffer = new StringBuilder();
        public string parsedStringData { get; set; }
        //TODO DELETE CODE with counters
        public int testcounter = 0;
        public int tcount = 0;



        private const int MaxResponse = 50;
        private byte[] response = new byte[MaxResponse];
        private int responseLength;



        public void setSerialPort() 
        {
            sPort = new SerialPort(serialportName, baudrate, (Parity)Enum.Parse(typeof(Parity), parityStr, true), sdata, (StopBits)Enum.Parse(typeof(StopBits), stopBitsStr, true));
            sPort.DataReceived += new SerialDataReceivedEventHandler(serialPort_DataReceived);
        }

        public void openSerialPort() 
        {
            if (!sPort.IsOpen)
            {
                sPort.Open(); 
            }
        }

        public void closeSerialPort()
        {
            if (sPort.IsOpen)
            {
                sPort.Close();
            }
           
        }

        public void sendPrintCommand()
        {
            sPort.Open();
            sPort.Write("I am Printing" + ASCIIEncoding.ASCII.GetChars(new byte[] {13}).ToString());
            sPort.Write(baPRINT.ToString());
            System.Diagnostics.Debug.WriteLine("Data Was Printed");
            sPort.Close();
        }

        private void serialPort_DataReceived(Object Sender, SerialDataReceivedEventArgs e) 
        {
         
           
            SerialPort sp = (SerialPort)Sender;
            if (!sp.IsOpen)
            {
                sp.Open();
            }

            int cnt = sp.BytesToRead;
            for (int ix = 0; ix < cnt; ++ix)
            {
                byte b = (byte)sp.ReadByte();

                //char [] strbyte = (Encoding.ASCII.GetChars(new byte[] { b }));
                if (responseLength == 0 && b == bSTART)
                {
                    continue;
                }
                var str = Encoding.ASCII.GetString(response, 0, responseLength);
                var strEnd = Encoding.ASCII.GetString(baEND);
                if (-1 == str.IndexOf(strEnd)) response[responseLength++] = b;
                else
                {
                   
                    spBuffer.Append(str);
                    while (parseSPBuffer(spBuffer))
                    {
                        //empty because parseSPBuffer returns bool
                    }

                    responseLength = 0;
                }
                if (responseLength >= MaxResponse)
                    responseLength = 0;
                
            }

            //string serialData = sp.ReadExisting();
            //spBuffer.Append(serialData);

            //while (parseSPBuffer(spBuffer))
            //{
            // //empty because parseSPBuffer returns bool
            //}
            tcount++;
            if(tcount >100) sp.Close();

            //TODO: handle data
            System.Diagnostics.Debug.WriteLine("Data Was Received");
            System.Diagnostics.Debug.Write(spBuffer.ToString());
        }

        private bool parseSPBuffer(StringBuilder spb) 
        {
          
            bool keepProcessing = true;
            string strBuffer = spb.ToString();
            int startPosition = strBuffer.IndexOf(bSTART.ToString());
            int endPosition = strBuffer.IndexOf(baEND.ToString());

            if (0 <= startPosition && 0 < endPosition && endPosition > startPosition)
            {
                if (0 < endPosition && endPosition > startPosition)
                { //found correct data
                    parsedStringData = strBuffer.Substring(startPosition, endPosition + 1);
                    keepProcessing = false;
                }
                else
                { //data not correct; clear buffer and 
                    spb.Clear();
                }

            }
            else if (-1 == startPosition && 0 != strBuffer.Length)
            { //string doesn't have Start string; can clear
                spb.Clear();
            }

            //TODO REMOVE
            testcounter += 1;
            if (testcounter >= 500) {
                keepProcessing = false;
                closeSerialPort();
            }
            return keepProcessing;
        }

    }
}