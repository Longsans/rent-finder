import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const defaultPadding = 16.0;
const primaryColor = Colors.white;
const textColor = Color(0xFF318E99);

class House extends Equatable {
  final String id;
  final String imgSrc, location, price, category, description, owner, avatar;
  final int numOfBed, numOfBath, area;
  final List<String> imgList;
  final LatLng latLocation;

  House(
      {this.owner,
      this.id,
      this.avatar,
      this.description,
      this.imgList,
      this.imgSrc,
      this.location,
      this.price,
      this.numOfBed,
      this.numOfBath,
      this.area,
      this.latLocation,
      this.category});

  @override
  List<Object> get props => [
        id,
        owner,
        avatar,
        description,
        imgList,
        imgSrc,
        location,
        price,
        numOfBed,
        numOfBath,
        area,
        latLocation,
        category
      ];
}

List<House> houses = [
  House(
      id: '1',
      area: 80,
      numOfBath: 1,
      numOfBed: 2,
      location:
          '3 Nguyễn Bỉnh Khiêm, Phường Bến Nghé, Quận 1, Thành Phố Hồ Chí Minh',
      price: "35,000,000 mỗi tháng",
      imgSrc: 'assets/images/nha.jpg',
      category: 'Căn hộ',
      description:
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",
      imgList: [
        'assets/images/noithat1.jpg',
        'assets/images/noithat2.jpg',
        'assets/images/noithat3.jpg',
        'assets/images/noithat4.jpg',
        'assets/images/noithat5.jpg'
      ],
      owner: 'Cường Nguyễn',
      avatar: 'assets/images/avatar1.png',
      latLocation: LatLng(10.78558819984757, 106.70663696833627)),
  House(
      id: '2',
      area: 80,
      numOfBath: 1,
      numOfBed: 2,
      location: '1 Nguyễn Cư Trinh, Quận 1, Thành Phố Hồ Chí Minh',
      price: "35,000,000 mỗi tháng",
      imgSrc: 'assets/images/nha1.jpg',
      category: 'Chung cư',
      imgList: [
        'assets/images/noithat1.jpg',
        'assets/images/noithat2.jpg',
        'assets/images/noithat3.jpg',
        'assets/images/noithat4.jpg',
        'assets/images/noithat5.jpg'
      ],
      owner: 'Long Đỗ',
      avatar: 'assets/images/avatar2.png',
      description:
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",
      latLocation: LatLng(10.764281398809217, 106.68965913340197)),
  House(
      id: '3',
      area: 200,
      numOfBath: 3,
      numOfBed: 6,
      location: '92 - 94 Nam Kỳ Khởi Nghĩa, Quận 1, Thành Phố Hồ Chí Minh',
      price: "4,000,000đ",
      imgSrc: 'assets/images/nha2.jpg',
      category: 'Nhà trọ',
      imgList: [
        'assets/images/noithat1.jpg',
        'assets/images/noithat2.jpg',
        'assets/images/noithat3.jpg',
        'assets/images/noithat4.jpg',
        'assets/images/noithat5.jpg'
      ],
      owner: 'Hào Đinh',
      avatar: 'assets/images/avatar3.jpg',
      description:
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",
      latLocation: LatLng(10.772815969366393, 106.70123569717161)),
  House(
      id: '4',
      area: 80,
      numOfBath: 1,
      numOfBed: 2,
      location:
          '3 Nguyễn Bỉnh Khiêm, Phường Bến Nghé, Quận 1, Thành Phố Hồ Chí Minh',
      price: "35,000,000 mỗi tháng",
      imgSrc: 'assets/images/nha.jpg',
      category: 'Căn hộ',
      description:
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",
      imgList: [
        'assets/images/noithat1.jpg',
        'assets/images/noithat2.jpg',
        'assets/images/noithat3.jpg',
        'assets/images/noithat4.jpg',
        'assets/images/noithat5.jpg'
      ],
      owner: 'Cường Nguyễn',
      avatar: 'assets/images/avatar1.png',
      latLocation: LatLng(10.78558819984757, 106.70663696833627)),
  House(
      id: '5',
      area: 80,
      numOfBath: 1,
      numOfBed: 2,
      location: '1 Nguyễn Cư Trinh, Quận 1, Thành Phố Hồ Chí Minh',
      price: "35,000,000 mỗi tháng",
      imgSrc: 'assets/images/nha1.jpg',
      category: 'Chung cư',
      imgList: [
        'assets/images/noithat1.jpg',
        'assets/images/noithat2.jpg',
        'assets/images/noithat3.jpg',
        'assets/images/noithat4.jpg',
        'assets/images/noithat5.jpg'
      ],
      owner: 'Long Đỗ',
      avatar: 'assets/images/avatar2.png',
      description:
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",
      latLocation: LatLng(10.764281398809217, 106.68965913340197)),
  House(
      id: '6',
      area: 200,
      numOfBath: 3,
      numOfBed: 6,
      location: '92 - 94 Nam Kỳ Khởi Nghĩa, Quận 1, Thành Phố Hồ Chí Minh',
      price: "4,000,000đ",
      imgSrc: 'assets/images/nha2.jpg',
      category: 'Nhà trọ',
      imgList: [
        'assets/images/noithat1.jpg',
        'assets/images/noithat2.jpg',
        'assets/images/noithat3.jpg',
        'assets/images/noithat4.jpg',
        'assets/images/noithat5.jpg'
      ],
      owner: 'Hào Đinh',
      avatar: 'assets/images/avatar3.jpg',
      description:
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable",
      latLocation: LatLng(10.772815969366393, 106.70123569717161)),
];

class UserProvider {
  List<House> getLikedHouses() {
    return [houses[0], houses[1]];
  }
}

List<House> LikedHouses = [];

class User {
  final String id, name, email;
  final List<House> likedHouses;

  User({this.id, this.name, this.email, this.likedHouses});
}
