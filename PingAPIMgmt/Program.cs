using System;
using System.Net;
using System.Threading.Tasks;
using System.Threading;



namespace PingAPIMgmt
{
    public class ConsumeEventSync
    {
        public void GetAllEventData() //Get All Events Records  
        { 
            using (var client = new WebClient()) //WebClient  
            {
                client.Headers.Add("Content-Type:application/json"); //Content-Type  
                client.Headers.Add("Accept:application/json");
                client.Headers.Add("Ocp-Apim-Subscription-Key:57fa26836bc3482195f6e987a564f102");
                var result = client.DownloadString("https://apimtestfeoifkldf.azure-api.net/northeu/api/HttpTriggerCSharp1"); //URI  
                DateTime currentDateTime = DateTime.Now;

                Console.WriteLine("{0} - {1}",currentDateTime,Environment.NewLine + result);
            }
    

        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            CancellationTokenSource cts = new CancellationTokenSource();

            ConsumeEventSync objsync = new ConsumeEventSync();
            while (true)
            {
                if (cts.IsCancellationRequested)
                {
                    Console.WriteLine("Exiting...");
                    break;
                }

                var t = Task.Factory.StartNew(async delegate
                {
                    await Task.Delay(1000);
                    objsync.GetAllEventData();
                }).Unwrap();



            }

            System.Console.ReadLine();

            System.Console.CancelKeyPress += (s, e) =>

            {

                e.Cancel = true;

                cts.Cancel();

                Console.WriteLine("Exiting...");

            };
            
        }
    }
}