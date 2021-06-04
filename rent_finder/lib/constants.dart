import 'package:flutter/material.dart';

const defaultPadding = 16.0;
const primaryColor = Colors.white;
const textColor = Color(0xFF318E99);

class RecentHome {
  final String imgSrc, location, price;
  final int numOfBed, numOfBath, area;
  final bool isLiked;

  RecentHome(
      {this.imgSrc,
      this.isLiked, 
      this.location,
      this.price,
      this.numOfBed,
      this.numOfBath,
      this.area});
}
class House {
  final String imgSrc, location, price, category;
  final int numOfBed, numOfBath, area;
  final bool isLiked;


  House(
      {this.imgSrc,
      this.isLiked, 
      this.location,
      this.price,
      this.numOfBed,
      this.numOfBath,
      this.area,
      this.category});
}

List<RecentHome> recentHomes = [
  RecentHome(
    area: 80,
    numOfBath: 1,
    numOfBed: 2,
    location: '3 Nguyễn Bỉnh Khiêm, Phường Bến Nghé, Quận 1, Thành Phố Hồ Chí Minh',
    price: "35,000,000 mỗi tháng",
    imgSrc: 'assets/images/nha.jpg',
    isLiked: true,
  ),
  RecentHome(
    area: 80,
    numOfBath: 1,
    numOfBed: 2,
    location: 'Khu Phố 6, Phường Linh Trung, Quận Thủ Đức',
    price: "35,000,000 mỗi tháng",
    imgSrc: 'assets/images/nha1.jpg',
    isLiked: false
  ),
  RecentHome(
    area: 200,
    numOfBath: 3,
    numOfBed: 6,
    location: '92 - 94 Nam Kỳ Khởi Nghĩa, Quận 1, Thành Phố Hồ Chí Minh',
    price: "4,000,000đ",
    imgSrc: 'assets/images/nha2.jpg',
    isLiked: true
  ),
];
List<House> houses = [
  House(
    area: 80,
    numOfBath: 1,
    numOfBed: 2,
    location: '3 Nguyễn Bỉnh Khiêm, Phường Bến Nghé, Quận 1, Thành Phố Hồ Chí Minh',
    price: "35,000,000 mỗi tháng",
    imgSrc: 'assets/images/nha.jpg',
    isLiked: true,
    category: 'Căn hộ',
  ),
  House(
    area: 80,
    numOfBath: 1,
    numOfBed: 2,
    location: 'Khu Phố 6, Phường Linh Trung, Quận Thủ Đức',
    price: "35,000,000 mỗi tháng",
    imgSrc: 'assets/images/nha1.jpg',
    isLiked: false,
    category: 'Chung cư',
  ),
  House(
    area: 200,
    numOfBath: 3,
    numOfBed: 6,
    location: '92 - 94 Nam Kỳ Khởi Nghĩa, Quận 1, Thành Phố Hồ Chí Minh',
    price: "4,000,000đ",
    imgSrc: 'assets/images/nha2.jpg',
    isLiked: true,
    category: 'Nhà trọ',
  ),
];
