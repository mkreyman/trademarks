defmodule Trademarks.Downloader do
  require Logger

  @user_agent [{"User-agent", Application.get_env(:trademarks, :user_agent)}]
  @download_options [hackney: [:insecure], timeout: 10000, recv_timeout: 10000]
  @trademarks_url Application.get_env(:trademarks, :trademarks_url)
  @temp_page Application.get_env(:trademarks, :temp_page)
  @temp_file Application.get_env(:trademarks, :temp_file)

  def download do
    fetch_page()
    fetch_file()
  end

  defp fetch_page do
    download(@trademarks_url, @temp_page)
  end

  defp fetch_file do
    download(file_url(), @temp_file)
  end

  defp download(url, output_filename) do
    proxy = Application.get_env(:trademarks, :proxy)

    download_options =
      if proxy do
        @download_options ++ [proxy: proxy]
      else
        @download_options
      end

    HTTPoison.get!(url, @user_agent, download_options)
    |> handle_response(output_filename)
  end

  defp file_url do
    @trademarks_url <> filename()
  end

  defp filename do
    with {:ok, html} <- File.read(@temp_page) do
      html
      |> Floki.find("td > a[href$=zip]")
      |> Floki.attribute("href")
      |> List.last()
    end
  end

  defp handle_response(%{status_code: 200, body: body}, output_filename) do
    Logger.info(fn ->
      "Successfully downloaded #{output_filename}"
    end)

    File.write!(output_filename, body)
    {:ok, output_filename}
  end

  defp handle_response(%{status_code: status, body: _}, _) do
    Logger.error(fn ->
      "Error #{status} returned"
    end)

    {:error, :download_failed}
  end
end
