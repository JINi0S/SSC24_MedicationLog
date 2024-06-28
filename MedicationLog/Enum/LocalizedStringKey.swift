//
//  LocalizedStringKey.swift
//
//
//  Created by Lee Jinhee on 2/25/24.
//

import Foundation

enum LocalizedStringKey: String {
    // 공통 텍스트
    case ok = "OK"
    case cancel = "Cancel"
 
    
    var eng: String {
        switch self {
        case .ok:
            "OK"
        case .cancel:
            "Cancel"
        }
    }
        
 
    enum Onboarding1 {
        case title
        case content
        case example1
        case example2
        case example3
        case example4
        case example5
        var eng: String {
            switch self {
            case .title:
                "A reason why it's necessary"
            case .content:
                "Parkinson's disease is a condition caused by a deficiency of dopamine, a neurotransmitter in the brain, and accurate diagnosis and appropriate treatment are necessary. To achieve this, it is important for patients to record their symptoms and treatment progress, for which they create a medication diary. Parkinson's medication diary plays a crucial role in the treatment and management of Parkinson's disease patients. Through this, patients and doctors can establish treatment plans together and effectively manage symptoms."
            case .example1:
                "Confirming medication intake"
            case .example2:
                "Assessing medication effectiveness"
            case .example3:
                "Identifying side effects"
            case .example4:
                "Preventing duplicate medication"
            case .example5:
                "Utilizing for treatment planning"
            }
        }
        
        var kor: String {
            switch self {
            case .title:
                "필요성"
            case .content:
                "파킨슨병은 뇌의 신경전달물질인 도파민의 부족으로 인해 발생하는 질환으로, 정확한 진단과 적절한 치료가 필요합니다.\n이를 위해 환자는 자신의 증상과 치료 과정을 기록하는 것이 중요하며, 이를 위해 투약일지를 작성합니다.\n파킨슨 약 투약일지는 파킨슨 병 환자의 치료와 관리에 매우 중요한 역할을 합니다.\n이를 통해 환자와 의사가 함께 치료 계획을 수립하고, 증상을 효과적으로 조절할 수 있습니다."
            case .example1:
                "약 복용 여부 확인"
            case .example2:
                "약의 효과 파악"
            case .example3:
                "부작용 파악"
            case .example4:
                "약의 중복 복용 방지"
            case .example5:
                "치료 계획에 활용"
            }
        }
    }
    
    enum Onboarding2 {
        case title
        case content
        case example1
        case example2
        case example3
        case example4
        
        case example1_1
        case example2_1
        case example3_1
        case example4_1
        
        var eng: String {
            switch self {
            case .title:
                "Advantage"
            case .content:
                "Writing a medication log has several benefits."
            case .example1:
                "You can check if you have taken your medication."
            case .example2:
                "Evaluate the efficacy of the medication"
            case .example3:
                "You can identify side effects."
            case .example4:
                "You can develop a treatment plan."
            case .example1_1:
                "By writing a medication log, you can easily check if you have taken your medication every day. This can help prevent worsening of symptoms that may occur if you do not take your medication."
            case .example2_1:
                "By keeping a medication log, you can determine when the medication takes effect and how long it lasts. This allows you to consult with your doctor to adjust the appropriate dosage and timing."
            case .example3_1:
                "By keeping a medication log, you can identify when side effects occur and what symptoms they cause. This allows you to consult with your doctor to prevent or address side effects."
            case .example4_1:
                "By understanding the effectiveness and side effects of your medication through a medication log, you can work with your doctor to develop an appropriate treatment plan. This can help effectively manage Parkinson's symptoms and improve quality of life."
            }
        }
        var kor: String {
            switch self {
            case .title:
                "이점"
            case .content:
                "투약일지를 작성하면 다음과 같은 장점이 있습니다."
            case .example1:
                "약 복용 여부를 확인할 수 있습니다."
            case .example2:
                "약의 효과를 파악할 수 있습니다."
            case .example3:
                "부작용을 파악할 수 있습니다."
            case .example4:
                "치료 계획을 세울 수 있습니다."
            case .example1_1:
                "투약일지를 쓰면 매일 약을 복용했는지 여부를 쉽게 확인할 수 있습니다. 이를 통해 약을 복용하지 않아 발생할 수 있는 증상 악화를 예방할 수 있습니다."
            case .example2_1:
                "투약일지를 통해 약의 효과가 언제 나타나는지, 얼마나 지속되는지 등을 파악할 수 있습니다. 이를 통해 의사와 상담하여 적절한 용량과 복용 시간을 조절할 수 있습니다"
            case .example3_1:
                "투약일지를 쓰면 약의 부작용이 언제 나타나는지, 어떤 증상이 나타나는지 등을 파악할 수 있습니다. 이를 통해 의사와 상담하여 부작용을 예방하거나 대처할 수 있습니다."
            case .example4_1:
                "투약일지를 통해 약의 효과와 부작용을 파악하면, 이를 바탕으로 의사와 함께 적절한 치료 계획을 세울 수 있습니다. 이를 통해 파킨슨 병의 증상을 효과적으로 조절하고, 삶의 질을 향상시킬 수 있습니다."
            }
        }
    }
    
    enum Onboarding3 {
        case title
        case content
        case example1
        case example2
        case example3
        
        var eng: String {
            switch self {
            case .title:
                 "With the Medication Log"
            case .content:
                "You can systematically manage your health and establish an effective treatment plan with your healthcare provider."
            case .example1:
                "1. It enables the management of medication records."
            case .example2:
                "2. You can manage the data systematically and analyze the medication's intake patterns and effectiveness through it."
            case .example3:
                "3. It can be shared with family members or medical staff, helping them understand and manage the patient's condition together."
            }
        }
        
        var kor: String {
            switch self {
            case .title:
                 "투약일지로"
            case .content:
                "건강을 체계적으로 관리하고, 의료진과 함께 효과적인 치료 계획을 수립할 수 있습니다."
            case .example1:
                "1. 투약 기록의 저장 및 관리가 가능합니다."
            case .example2:
                "2. 데이터를 체계적으로 관리할 수 있고, 이를 통해 약의 복용 패턴과 효과를 분석할 수 있습니다."
          
            case .example3:
                "3. 가족이나 의료진과 공유할 수 있어, 환자의 상태를 함께 파악하고 관리할 수 있도록 돕습니다."
            }
        }
    }
}
