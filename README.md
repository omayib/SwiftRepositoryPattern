# SwiftRepositoryPattern
the implementation of repository pattern on swift for handling multiple data source.

this is the real implementation of reposiory pattern on iOS project. The project is using two repository
1. Remote API. <br/>
Getting the data from server. It is covered on `RemoteRepository` class. To make it simple, i setup my local server using [jsonplaceholder](www.jsonplaceholder.typicode.com) and here is the initial data
```
{
  "todos": [
    {
      "is_completed": "0",
      "tempId": "710BBEC4-8A7B-486F-9329-412DFD5FB738",
      "title": "coding",
      "id": "SJcbh6mtb"
    },
    {
      "is_completed": "0",
      "tempId": "FAF6D1D3-A8B6-4E46-B25F-484B783EDD99",
      "title": "takbiran5",
      "id": "SyXOu_utb"
    }
  ]
}
```

2. Cached Data.<br/>
Getting the data from cache memory. It is implemented on `CachedRepository` class.
