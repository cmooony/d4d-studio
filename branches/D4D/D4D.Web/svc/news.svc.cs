﻿using System;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Collections.Generic;
using D4D.Model;
using D4D.DAL;

namespace D4D.Web.svc
{
    [ServiceContract(Namespace = "")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class news
    {
        // Add [WebGet] attribute to use HTTP GET
        [OperationContract]
        public void DoWork()
        {
            // Add your operation implementation here
            return;
        }

        [OperationContract]
        [WebGet(RequestFormat=WebMessageFormat.Json,BodyStyle=WebMessageBodyStyle.WrappedRequest,ResponseFormat=WebMessageFormat.Json)]
        public IList<News> GetNewsList(int p,int size)
        {
            return newsDAL.GetList(null, p * size+1, size); 
        }



        private NewsDAL newsDAL = new NewsDAL();
        // Add more operations here and mark them with [OperationContract]
    }
}
