module ExerciseModule {
    // Array modülüne gerek yoksa import satırını kaldırıyoruz.

    // Egzersiz türü
    type Exercise = {
        name: Text;
        description: Text;
        equipment: [Text];  // Kullanılacak ekipmanlar
    };

    // Ağrı bölgeleri
    type PainRegion = {
        name: Text;
        exercises: [Exercise];  // Ağrı bölgesine özel egzersizler
    };

    // Ağrı bölgeleri ve önerilen egzersizler
    var painRegions : [PainRegion] = [
        {
            name = "Sırt";
            exercises = [
                { 
                    name = "Köprü Egzersizi";
                    description = "Sırt kaslarını güçlendirmek için sırt üstü yatarak kalçayı yukarı kaldırın.";
                    equipment = ["Yogamat"];
                },
                { 
                    name = "Lat Pull Down";
                    description = "Sırt kaslarını çalıştıran bir makine egzersizi.";
                    equipment = ["Lat Pull Down Makinesi"];
                }
            ];
        },
        {
            name = "Boyun";
            exercises = [
                { 
                    name = "Boyun Germe";
                    description = "Boynu sağa, sola, yukarı ve aşağıya doğru nazikçe gerin.";
                    equipment = ["Yogamat"];
                },
                { 
                    name = "Kendi Kendine Masaj";
                    description = "Boyun kaslarına parmak uçlarınızla hafifçe masaj yapın.";
                    equipment = ["Masaj Topu"];
                }
            ];
        },
        {
            name = "Diz";
            exercises = [
                { 
                    name = "Diz Çevirmesi";
                    description = "Dizleri hafifçe sağa ve sola çevirerek esnetin.";
                    equipment = ["Yogamat"];
                },
                { 
                    name = "Leg Press";
                    description = "Bacak kaslarını çalıştıran bir makine egzersizi.";
                    equipment = ["Leg Press Makinesi"];
                }
            ];
        },
        {
            name = "Omuz";
            exercises = [
                { 
                    name = "Dumbbell Press";
                    description = "Omuz kaslarını çalıştırmak için dumbbell kullanarak press hareketi yapın.";
                    equipment = ["Dumbbell"];
                },
                { 
                    name = "Shoulder Shrugs";
                    description = "Omuz kaslarını çalıştıran basit bir hareket, dumbbell kullanarak omuzları yukarı kaldırın.";
                    equipment = ["Dumbbell"];
                }
            ];
        }
    ];

    // Kullanıcıya uygun egzersizleri ve ekipmanları öner
    public func getSuggestionsForPainRegion(regionName: Text) : ?Text {
        switch (Array.find(painRegions, func(r) { r.name == regionName })) {
            case (?region) {
                var response = "Ağrı Bölgesi: " # region.name # "\n";
                for (exercise in region.exercises) {
                    response := response # "Egzersiz: " # exercise.name # "\n";
                    response := response # "Açıklama: " # exercise.description # "\n";
                    response := response # "Ekipman: " # Array.toText(exercise.equipment) # "\n\n";
                };
                return response;
            };
            case (_) { 
                // Eğer bölge bulunamazsa null döndürüyoruz
                return null; 
            };
        };
    }

   // Ağrı bölgesine göre egzersiz önerisi
 
    public func getExercisesByPainRegion(regionName: Text) : ?[Exercise] {
        return switch (Array.find(painRegions, func(r) { r.name == regionName })) {
            case (?region) { 
                // Eğer bölge bulunduysa, egzersizleri döndürüyoruz
                ?region.exercises;
            };
            case (_) { 
                // Bölge bulunamadıysa null döndürüyoruz
                null;
            };
        };
    }
};
