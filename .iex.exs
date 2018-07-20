alias Trademarks.Util.{
  Downloader,
  Parser,
  Persistor,
  Search
}

alias Neo4j.Tasks.{
  Init,
  Drop,
  Ingest
}


alias Trademarks.Models.Nodes.{
  Address,
  Attorney,
  CaseFile,
  Correspondent,
  EventStatement,
  Owner,
  Statement,
  Trademark
}

alias Trademarks.Models.Links.{
  Aka,
  BelongsTo,
  CommunicatesWith,
  Describes,
  FiledBy,
  FiledFor,
  Files,
  Locates,
  Owns,
  PartyTo,
  RepresentedBy,
  Represents,
  Updates
}