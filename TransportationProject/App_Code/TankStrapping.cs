using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class TankStrapping
    {
        private int _MSID;
        private bool _IsStrapStart;

        public TankStrapping()
        {
            this.TankNum = 0;
            this.Temp = 0;
            this.Feet = 0;
            this.Inches = 0;
            this.Numerator = 0;
            this.Denominator = 0;
            this.GallonsConvertedFromFraction = 0;
            this.GallonsConvertedFromFtAndIn = 0;
            this.GallonsTotal = 0;
            this.Flush = 0;

        }
        public int MSID {
            get
            {
                return this._MSID;
            }
            set {
                this._MSID = value;
            }
        }
        public bool isStrapStart
        {
          
            get
            {
                return this._IsStrapStart;
            }

            set
            {
                this._IsStrapStart = value;
            }
        }
        public float Temp { get; set; }
        public int Feet { get; set; }
        public int Inches { get; set; }
        public int Numerator { get; set; }
        public int Denominator { get; set; }
        public float GallonsConvertedFromFtAndIn { get; set; }
        public float GallonsConvertedFromFraction { get; set; }
        public float GallonsTotal { get; set; }
        public int TankNum { get; set; }
        public float Flush { get; set; }
    }
}