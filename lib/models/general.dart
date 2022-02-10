import 'dart:ui';

class Charts {
  Charts({
    this.title = "",
    this.country = "",
  });
  String title;
  String country;
}

class Artist {
  Artist({
    this.name = "",
    this.imageLink = "",
  });
  String name;
  String imageLink;
}

class Song {
  Song({
    this.name = "",
    this.imageLink = "",
  });
  String name;
  String imageLink;
}

class Playlist {
  String name;
  List<Song>? songs;
  Playlist({this.name = "",this.songs});

//List<Song> songs = List<Song>.empty(growable: true);
}
List<Playlist> userPlaylist = [
  Playlist(
      name: "LOFI Songs",
      songs: [
        Song(name: "Levitating",imageLink: ""),
        Song(name: "In My Blood",imageLink: ""),
        Song(name: "Mood",imageLink: ""),
      ]
  ),
  Playlist(
      name: "Playlist 1",
      songs: [
        Song(name: "Levitating",imageLink: ""),
        Song(name: "In My Blood",imageLink: ""),
        Song(name: "Mood",imageLink: ""),
      ]
  ),
  Playlist(
      name: "Playlist 2",
      songs: [
        Song(name: "Levitating",imageLink: ""),
        Song(name: "In My Blood",imageLink: ""),
        Song(name: "Mood",imageLink: ""),
      ]
  ),
];


class User {
  String name;
  String email;
  String location;
  int avatarIndex;
  int followingArtists;
  int playlists;
  User({
    this.name = "",
    this.avatarIndex = 1,
    this.followingArtists = 0,
    this.playlists = 0,
    this.email = "",
    this.location = "",
  });
}

List<User> users = [
  User(
    name: "Divyam Mistry",
    email: "divsmistry30@gmail.com",
    location: "Bilimora, Gujarat",
    avatarIndex: 1,
    followingArtists: 3,
    playlists: 3,
  ),
  User(
    name: "Arnish Mistry",
    email: "arnishmistry@gmail.com",
    location: "Surat, Gujarat",
    avatarIndex: 1,
    followingArtists: 3,
    playlists: 3,
  ),
];