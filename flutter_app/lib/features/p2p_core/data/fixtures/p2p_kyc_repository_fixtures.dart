part of '../repositories/mock_p2p_repository.dart';

const List<P2PKycTierDraft> _p2pKycTiers = [
  P2PKycTierDraft(
    id: 1,
    name: 'Basic',
    badge: 'Cơ bản',
    toneKey: 'success',
    iconKey: 'shield',
    requirements: [
      P2PKycRequirementDraft(label: 'CMND/CCCD/Passport', iconKey: 'file'),
      P2PKycRequirementDraft(label: 'OCR + Face Match', iconKey: 'camera'),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 50000000,
      dailySell: 50000000,
      monthlyVolume: 500000000,
    ),
    benefits: [
      'Giao dịch P2P cơ bản',
      'Tạo tối đa 3 quảng cáo',
      'Rút tối đa 20M VND/ngày',
    ],
    verificationTime: '10 phút',
    status: P2PKycTierStatus.current,
  ),
  P2PKycTierDraft(
    id: 2,
    name: 'Intermediate',
    badge: 'Trung cấp',
    toneKey: 'p2p',
    iconKey: 'badge',
    requirements: [
      P2PKycRequirementDraft(label: 'KYC Basic', iconKey: 'check'),
      P2PKycRequirementDraft(label: 'Proof of Address', iconKey: 'file'),
      P2PKycRequirementDraft(label: 'Selfie với ID', iconKey: 'camera'),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 200000000,
      dailySell: 200000000,
      monthlyVolume: 2000000000,
    ),
    benefits: [
      'Tất cả quyền Basic',
      'Tạo không giới hạn quảng cáo',
      'Rút tối đa 100M VND/ngày',
      'Ưu tiên hỗ trợ',
    ],
    verificationTime: '24 giờ',
    status: P2PKycTierStatus.available,
  ),
  P2PKycTierDraft(
    id: 3,
    name: 'Advanced',
    badge: 'Nâng cao',
    toneKey: 'warning',
    iconKey: 'star',
    requirements: [
      P2PKycRequirementDraft(label: 'KYC Intermediate', iconKey: 'check'),
      P2PKycRequirementDraft(
        label: 'Video Call Verification',
        iconKey: 'video',
      ),
      P2PKycRequirementDraft(label: 'Source of Funds', iconKey: 'file'),
      P2PKycRequirementDraft(
        label: 'Enhanced Due Diligence',
        iconKey: 'shield',
      ),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 1000000000,
      dailySell: 1000000000,
      monthlyVolume: 10000000000,
    ),
    benefits: [
      'Tất cả quyền Intermediate',
      'Merchant Badge',
      'API Trading Access',
      'Dedicated Support 24/7',
      'Phí ưu đãi đặc biệt',
    ],
    verificationTime: '3-5 ngày làm việc',
    status: P2PKycTierStatus.available,
  ),
];

const List<P2PKycStatusStepDraft> _p2pKycStatusSteps = [
  P2PKycStatusStepDraft(
    id: 'identity',
    label: 'Identity Verification',
    description: 'CMND/CCCD/Passport + OCR',
    iconKey: 'file',
    status: P2PKycStepStatus.completed,
    completedAt: '2026-03-04 14:35',
  ),
  P2PKycStatusStepDraft(
    id: 'face_match',
    label: 'Face Match',
    description: 'So khớp khuôn mặt với ID',
    iconKey: 'face',
    status: P2PKycStepStatus.completed,
    completedAt: '2026-03-04 14:36',
  ),
  P2PKycStatusStepDraft(
    id: 'address_proof',
    label: 'Address Proof',
    description: 'Hóa đơn tiện ích / Bank statement',
    iconKey: 'upload',
    status: P2PKycStepStatus.processing,
    estimatedTime: '2-4 giờ',
  ),
  P2PKycStatusStepDraft(
    id: 'selfie_verification',
    label: 'Selfie Verification',
    description: 'Selfie với ID card',
    iconKey: 'camera',
    status: P2PKycStepStatus.waiting,
    estimatedTime: '10 phút',
    actionLabel: 'Bắt đầu',
    actionRoute: '/p2p/kyc/selfie',
  ),
  P2PKycStatusStepDraft(
    id: 'compliance_review',
    label: 'Compliance Review',
    description: 'Xem xét cuối cùng',
    iconKey: 'shield',
    status: P2PKycStepStatus.waiting,
    estimatedTime: '1-2 ngày làm việc',
  ),
];

const List<P2PIdentityDocumentTypeDraft> _p2pIdentityDocumentTypes = [
  P2PIdentityDocumentTypeDraft(
    id: 'cccd',
    label: 'Căn cước công dân',
    description: 'CCCD gắn chip (12 số)',
    iconKey: 'id_card',
  ),
  P2PIdentityDocumentTypeDraft(
    id: 'cmnd',
    label: 'Chứng minh nhân dân',
    description: 'CMND cũ (9 số)',
    iconKey: 'badge',
  ),
  P2PIdentityDocumentTypeDraft(
    id: 'passport',
    label: 'Hộ chiếu',
    description: 'Passport quốc tế',
    iconKey: 'passport',
  ),
];

const List<String> _p2pIdentityGuidelines = [
  'Đảm bảo ảnh rõ nét, không bị mờ hoặc nhòe',
  'Chụp toàn bộ giấy tờ, không bị cắt góc',
  'Không chụp qua màn hình hoặc ảnh photocopy',
  'Ánh sáng đủ, không bị lóa hoặc bóng tối',
  'Thông tin cá nhân phải đọc được rõ ràng',
];

const List<String> _p2pIdentitySecurityNotes = [
  'Tài liệu được mã hóa end-to-end',
  'Chỉ team Compliance được xem',
  'Tự động xóa sau 90 ngày nếu không approve',
  'Tuân thủ GDPR & Privacy Policy',
];

const List<P2PAddressDocumentTypeDraft> _p2pAddressDocumentTypes = [
  P2PAddressDocumentTypeDraft(
    id: 'utility',
    label: 'Hóa đơn tiện ích',
    description: 'Điện, nước, gas, internet',
    iconKey: 'receipt',
    examples: [
      'Hóa đơn điện EVN',
      'Hóa đơn nước',
      'Hóa đơn internet FPT/Viettel',
    ],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'bank_statement',
    label: 'Sao kê ngân hàng',
    description: 'Bank statement 3 tháng gần nhất',
    iconKey: 'bank_card',
    examples: ['Sao kê Vietcombank', 'Sao kê BIDV', 'Sao kê Techcombank'],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'gov_letter',
    label: 'Giấy tờ chính phủ',
    description: 'Giấy xác nhận tạm trú, hộ khẩu',
    iconKey: 'government',
    examples: ['Giấy xác nhận tạm trú', 'Sổ hộ khẩu'],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'lease',
    label: 'Hợp đồng thuê nhà',
    description: 'Lease agreement có công chứng',
    iconKey: 'home',
    examples: ['Hợp đồng thuê nhà công chứng'],
  ),
];

const List<String> _p2pAddressRequirements = [
  'Tài liệu phải trong vòng 3 tháng',
  'Địa chỉ phải khớp với thông tin đã khai báo',
  'Tên phải khớp với CMND/CCCD',
  'Tài liệu phải rõ nét, đầy đủ thông tin',
  'Chấp nhận cả bản scan và ảnh chụp',
];

const List<String> _p2pAddressSecurityNotes = [
  'Tài liệu được mã hóa AES-256',
  'Chỉ Compliance team được xem',
  'Tự động xóa sau 90 ngày nếu không approve',
  'Tuân thủ GDPR & PDPA',
];

const List<String> _p2pSelfieGuidelines = [
  'Giữ ID card cạnh khuôn mặt',
  'Đảm bảo khuôn mặt và ID rõ nét',
  'Ánh sáng đủ, không chói ngược',
  'Không đeo kính đen, khẩu trang',
  'Nhìn thẳng vào camera',
];

const List<String> _p2pSelfieTips = [
  'Sử dụng môi trường đủ sáng',
  'Giữ điện thoại ổn định',
  'Làm theo hướng dẫn từng bước',
  'Khuôn mặt nên ở chính giữa khung hình',
];

const List<P2PSelfieLivenessActionDraft> _p2pSelfieLivenessActions = [
  P2PSelfieLivenessActionDraft(
    id: 'smile',
    label: 'Mỉm cười',
    iconKey: 'smile',
  ),
  P2PSelfieLivenessActionDraft(
    id: 'blink',
    label: 'Chớp mắt 2 lần',
    iconKey: 'blink',
  ),
  P2PSelfieLivenessActionDraft(
    id: 'turn_left',
    label: 'Quay mặt sang trái',
    iconKey: 'turn_left',
  ),
  P2PSelfieLivenessActionDraft(
    id: 'turn_right',
    label: 'Quay mặt sang phải',
    iconKey: 'turn_right',
  ),
];

const List<String> _p2pVideoPreparationItems = [
  'CMND/CCCD gốc',
  'Môi trường đủ sáng',
  'Camera và mic hoạt động',
  'Thời gian 10-15 phút',
];

const List<P2PVideoTimeSlotDraft> _p2pVideoTimeSlots = [
  P2PVideoTimeSlotDraft(
    id: 'slot_0900',
    date: '2026-03-06',
    time: '09:00 - 09:30',
    available: true,
  ),
  P2PVideoTimeSlotDraft(
    id: 'slot_1000',
    date: '2026-03-06',
    time: '10:00 - 10:30',
    available: true,
  ),
  P2PVideoTimeSlotDraft(
    id: 'slot_1400',
    date: '2026-03-06',
    time: '14:00 - 14:30',
    available: false,
  ),
  P2PVideoTimeSlotDraft(
    id: 'slot_1500',
    date: '2026-03-07',
    time: '15:00 - 15:30',
    available: true,
  ),
];
