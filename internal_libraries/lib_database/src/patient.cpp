#include "patient.hpp"

#ifdef QT_DEBUG
#include "logger.hpp"
#endif

// void Patient::copyData(const Patient &other)
// {
//     this->patient_id = other.patient_id;
//     this->first_name = other.first_name;
//     this->last_name = other.last_name;
//     this->age = other.age;
//     this->birth_date = other.birth_date;
//     this->phone_number = other.phone_number;
//     this->gender = other.gender;
//     this->marital_status = other.marital_status;
// }

// bool Patient::isEqual(const Patient &other)
// {
//     bool isEqual = true;

//     if (this->first_name != other.first_name) {
//         isEqual = false;
//     }

//     if (this->last_name != other.last_name) {
//         isEqual = false;
//     }

//     if (this->age != other.age) {
//         isEqual = false;
//     }

//     if (this->birth_date != other.birth_date) {
//         isEqual = false;
//     }

//     if (this->phone_number != other.phone_number) {
//         isEqual = false;
//     }

//     if (this->gender != other.gender) {
//         isEqual = false;
//     }

//     if (this->marital_status != other.marital_status) {
//         isEqual = false;
//     }

//     return (isEqual);
// }
