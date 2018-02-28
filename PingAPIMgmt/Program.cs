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
                client.Headers.Add("[ENTER YOUR KEY HERE]");
                var result = client.DownloadString("[ENTER YOUR API URI HERE]"); //URI  
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