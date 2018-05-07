using BIF.SWE1.Interfaces;
using MyWebServer;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace DBS
{
    class Program
    {
        static void Main(string[] args)
        {
            PluginManager PlugMan = new PluginManager();

            IPAddress IpAddress = IPAddress.Parse("127.0.0.1");
            TcpListener Listener = new TcpListener(IpAddress, 8080);

            Console.WriteLine("Waiting for connections...");

            Listener.Start();
                        
            while (true)
            {
                TcpClient Client = Listener.AcceptTcpClient();
                Console.WriteLine("Connection accepted.");

                PlugMan.UpdatePlugins();

                try
                {
                    var ChildSocketThread = new Thread(() =>
                    {
                        bool do_this = true;
                        NetworkStream BrowserNetworkStream = Client.GetStream();
                        StreamWriter NetWriter = new StreamWriter(BrowserNetworkStream);

                        Request BrowserRequest = new Request(BrowserNetworkStream);

                        try
                        {
                            if (BrowserRequest.Url.RawUrl?.Contains("favicon") ?? false)
                            {
                                throw new FUFaviconException();
                            }
                        }
                        catch
                        {
                            Console.WriteLine("Favicon Request Eliminated");
                            do_this = false;
                        }

                        if (do_this)
                        {
                            IPlugin HandlePlugin = PlugMan.GetPlugin(BrowserRequest);

                            IResponse PluginResponse = HandlePlugin.Handle(BrowserRequest);
                            PluginResponse.Send(BrowserNetworkStream);
                        }

                        Client.Close();
                    });

                    ChildSocketThread.Start();
                }
                catch
                {
                    Console.WriteLine("Client done goofed!");
                }
            }
        }
    }
}
