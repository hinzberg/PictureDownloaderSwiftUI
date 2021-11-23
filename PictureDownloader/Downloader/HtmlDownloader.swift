//  HtmlDownloader.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 01.03.21.

import Cocoa

public enum NetworkError: Error {
    case badURL, dataTaskFailed, requestFailed, unknown
}

public class HtmlDownloader
{
    private var dataTask: URLSessionDataTask? // For HTTP Get, HTML Source
    private let defaultSession = URLSession(configuration: .default)
    
    // Is this a valid Url? Very simple validation
    public func validate(string:String?) -> (isValid:Bool, url:URL?)
    {
        guard let urlString = string else {return (false, nil)}
        guard let url = URL(string: urlString) else {return (false, nil)}
        return (true, url)
    }
        
    public func downloadAsync(url:URL, completion: @escaping (Result<String, NetworkError> ) -> Void )
    {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: url)
        {
            data, response, error in
            
            if let error = error
            {
                print(error.localizedDescription)
                DispatchQueue.main.async() {
                    completion(.failure(.dataTaskFailed))
                }
            }
            
            if data != nil
            {
                let buffer = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                if let htmlSource = buffer {
                    DispatchQueue.main.async() {
                        completion(.success(htmlSource as String))
                    }
                }
            }
        }
        dataTask?.resume()
    }
}
