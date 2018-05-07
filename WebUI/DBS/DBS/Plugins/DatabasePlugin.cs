using BIF.SWE1.Interfaces;
using MyWebServer;
using MyWebServer.Plugins;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Reflection;
using System.Web;

namespace DBS.Plugins
{
    [AutoLoadPlugin]
    class DatabasePlugin : IPlugin
    {
        public float CanHandle(IRequest req)
        {
            return 1;
        }

        public IResponse Handle(IRequest req)
        {
            Response resp = new Response
            {
                StatusCode = 200
            };

            string fdir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\index.html";

            if (File.Exists(fdir))
            {
                string content = File.ReadAllText(fdir);
                string outfeed = "";

                if (req.ContentString != null)
                {
                    if (req.ContentString.Contains("movies="))
                    {
                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_SELECT_Genre_AllNames");
                            SqlCommand query = new SqlCommand(sqlString, db);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                int filter_num = 0;
                                outfeed = "<form action=\"\" method=\"POST\"><table><tr>";

                                while (rd.Read())
                                {
                                    outfeed += "<td><input type=\"checkbox\" name=\"mfilter_" + rd.GetString(0) + "\">" + rd.GetString(0) + "</input></td>";
                                    ++filter_num;
                                    outfeed += filter_num % 3 == 0 ? "</tr><tr>" : "";
                                }

                                outfeed += "</tr></table><button type=\"submit\">GO!</button></form>";
                            }

                            content = content.Replace("<pre>Filter Window</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("mfilter_"))
                    {
                        string reqcontent = HttpUtility.UrlDecode(req.ContentString);
                        string[] query_info = reqcontent.Replace("mfilter_", "").Replace("&", "").Split(new string[] { "=on" }, StringSplitOptions.None);

                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_SELECT_MovieXGenre_WhereMovieContainsGenre @GenreList");
                            SqlCommand query = new SqlCommand(sqlString, db);
                            query.CommandTimeout = 0;

                            string genrelist = "";

                            foreach (var genre in query_info)
                            {
                                if (genre != "")
                                {
                                    genrelist = genrelist != "" ? genrelist + "," + genre : genre;
                                }
                            }

                            query.Parameters.AddWithValue("@GenreList", genrelist);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                int numresults = 0;
                                outfeed = "<p>";

                                while (rd.Read())
                                {
                                    if (outfeed == "<p>")
                                    {
                                        outfeed += rd.GetString(0);
                                    }
                                    else
                                    {
                                        outfeed += ", " + rd.GetString(0);
                                    }
                                    ++numresults;
                                }

                                outfeed += "</p>";
                                outfeed = "<p>Number of Movies: " + numresults.ToString() + "</p>" + outfeed;
                            }

                            content = content.Replace("<pre>Output Window</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("mtitle="))
                    {
                        string reqcontent = HttpUtility.UrlDecode(req.ContentString);
                        int startindex = 0;
                        int length = 0;

                        startindex = reqcontent.IndexOf("=") + 1;
                        length = reqcontent.Substring(startindex).IndexOf("&");

                        string movie = reqcontent.Substring(startindex, length);

                        startindex = reqcontent.Substring(startindex).IndexOf("=") + startindex + 1;

                        string genre = reqcontent.Substring(startindex);

                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_INSERT_Movie_Genre_AddGenreToMovie @MovieTitle, @GenreName");
                            SqlCommand query = new SqlCommand(sqlString, db)
                            {
                                CommandTimeout = 0
                            };

                            query.Parameters.AddWithValue("@MovieTitle", movie);
                            query.Parameters.AddWithValue("@GenreName", genre);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                while (rd.Read())
                                {
                                    outfeed = "<p>" + rd.GetString(0) + "</p>";
                                }
                            }

                            content = content.Replace("<pre>Insert Result</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("cinemas="))
                    {
                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_SELECT_Cinemas_AllCinemaNamesAddresses");
                            SqlCommand query = new SqlCommand(sqlString, db);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                int filter_num = 0;
                                outfeed = "<form action=\"\" method=\"POST\"><table><tr>";

                                while (rd.Read())
                                {
                                    outfeed += "<td><input type=\"radio\" name=\"cfilter\" value=\"" + rd.GetInt32(0) + "\">Cinema: " + rd.GetString(1) + " City: " + rd.GetString(2) + " Street: " + rd.GetString(3) + "</input></td>";
                                    ++filter_num;
                                    outfeed += filter_num % 1 == 0 ? "</tr><tr>" : "";
                                }

                                outfeed += "</tr></table><button type=\"submit\">GO!</button></form>";
                            }

                            content = content.Replace("<pre>Filter Window</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("cfilter="))
                    {
                        string cinema_id = req.ContentString.Replace("cfilter=", "");

                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_SELECT_MovieXMovie_Cinema_AllMoviesInCinema @CinemaID");
                            SqlCommand query = new SqlCommand(sqlString, db)
                            {
                                CommandTimeout = 0
                            };

                            query.Parameters.AddWithValue("@CinemaID", cinema_id);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                int numresults = 0;
                                string movie_title = "";
                                outfeed = "<p>";

                                while (rd.Read())
                                {
                                    if (movie_title != rd.GetString(0))
                                    {
                                        outfeed += "<br>" + rd.GetString(0) + "<br>Actors:<br>";
                                        ++numresults;
                                    }

                                    outfeed += rd.GetString(1) + " " + rd.GetString(2) + ", Gender: " + rd.GetString(3) + "<br>";

                                    movie_title = rd.GetString(0);
                                }

                                outfeed += "</p>";
                                outfeed = "<p>Number of Movies: " + numresults.ToString() + "</p>" + outfeed;
                            }

                            content = content.Replace("<pre>Output Window</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("movie_cinema_mix="))
                    {
                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_SELECT_VIEW_CinemaXMovie_RealMovies");
                            SqlCommand query = new SqlCommand(sqlString, db)
                            {
                                CommandTimeout = 0
                            };

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                int numresults = 0;
                                int movie_num = 0;
                                outfeed = "<p>";
                                string last_cinema = "";

                                while (rd.Read())
                                {
                                    if (last_cinema != rd.GetString(0))
                                    {
                                        outfeed += "<br><h4>Cinema: " + rd.GetString(0) + "</h4><br>Movies:<br>";
                                        last_cinema = rd.GetString(0);
                                        movie_num = 0;
                                    }
                                    ++numresults;
                                    ++movie_num;
                                    outfeed += movie_num + ". " + rd.GetString(1) + "<br>";
                                }

                                outfeed += "</p>";
                                outfeed = "<p>Number of Movies: " + numresults.ToString() + "</p>" + outfeed;
                            }

                            content = content.Replace("<pre>View Result</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("tv_show_current="))
                    {
                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            db.Open();

                            var sqlString = string.Format("P_SELECT_VIEW_TV_Show_Episode_ListRealShowsAndEpisodes");
                            SqlCommand query = new SqlCommand(sqlString, db)
                            {
                                CommandTimeout = 0
                            };

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                int tv_shows = 0;
                                int episodes_total = 0;
                                outfeed = "<p>";
                                string current_show = "";

                                while (rd.Read())
                                {
                                    if (current_show != rd.GetString(0))
                                    {
                                        outfeed += "<br><h4>TV-Show: " + rd.GetString(0) + "</h4><br>Episodes:<br>";
                                        current_show = rd.GetString(0);
                                        ++tv_shows;
                                    }
                                    ++episodes_total;
                                    outfeed += "Episode " + rd.GetInt32(2) + ": " + rd.GetString(1) + "<br>";
                                }

                                outfeed += "</p>";
                                outfeed = "<p>Total TV-Shows: " + tv_shows + "<br>Total Episodes: " + episodes_total.ToString() + "</p>" + outfeed;
                            }

                            content = content.Replace("<pre>View Result</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("title=") && req.ContentString.Contains("release_year="))
                    {
                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            string reqcontent = HttpUtility.UrlDecode(req.ContentString);
                            int startindex = 0;
                            int length = 0;

                            startindex = reqcontent.IndexOf("=") + 1;
                            length = reqcontent.Substring(startindex).IndexOf("&");
                            string title = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            length = 4;
                            string release_year = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            string end_year = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            length = 1;
                            string running = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            string number_of_seasons = reqcontent.Substring(startindex);

                            db.Open();

                            var sqlString = string.Format("P_INSERT_TV_Show_OneRow @title, @release_year, @end_year, @running, @number_of_seasons");
                            SqlCommand query = new SqlCommand(sqlString, db)
                            {
                                CommandTimeout = 0
                            };

                            query.Parameters.AddWithValue("@title", title);
                            query.Parameters.AddWithValue("@release_year", release_year);
                            query.Parameters.AddWithValue("@end_year", end_year);
                            query.Parameters.AddWithValue("@running", running);
                            query.Parameters.AddWithValue("@number_of_seasons", number_of_seasons);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {                            
                                while (rd.Read())
                                {
                                    outfeed = "<p>" + rd.GetString(0) + "</p>";
                                }
                            }

                            content = content.Replace("<pre>Result</pre>", outfeed);

                            db.Close();
                        }
                    }
                    else if (req.ContentString.Contains("episode="))
                    {
                        using (SqlConnection db = new SqlConnection(@"Data Source=(local); Initial Catalog=DBS_Movies; Integrated Security=true;"))
                        {
                            string reqcontent = HttpUtility.UrlDecode(req.ContentString);
                            int startindex = 0;
                            int length = 0;

                            startindex = reqcontent.IndexOf("=") + 1;
                            length = reqcontent.Substring(startindex).IndexOf("&");
                            string tv_show = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            length = reqcontent.Substring(startindex).IndexOf("&");
                            string title = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            length = reqcontent.Substring(startindex).IndexOf("&");
                            string season = reqcontent.Substring(startindex, length);

                            startindex = reqcontent.Substring(startindex).IndexOf("=") + 1 + startindex;
                            length = reqcontent.Substring(startindex).IndexOf("&");
                            string episode = reqcontent.Substring(startindex);
                            
                            db.Open();

                            var sqlString = string.Format("P_INSERT_Episode_OneRow @tv_show, @title, @season, @episode");
                            SqlCommand query = new SqlCommand(sqlString, db)
                            {
                                CommandTimeout = 0
                            };

                            query.Parameters.AddWithValue("@tv_show", tv_show);
                            query.Parameters.AddWithValue("@title", title);
                            query.Parameters.AddWithValue("@season", season);
                            query.Parameters.AddWithValue("@episode", episode);

                            using (SqlDataReader rd = query.ExecuteReader())
                            {
                                while (rd.Read())
                                {
                                    outfeed = "<p>" + rd.GetString(0) + "</p>";
                                }
                            }

                            content = content.Replace("<pre>Result</pre>", outfeed);

                            db.Close();
                        }
                    }
                }

                resp.SetContent(content);
                resp.ContentType = ".html";
            }
            else
            {
                resp.StatusCode = 404;
                Console.WriteLine("No File found at: " + fdir);
            }

            return resp;
        }
    }
}
