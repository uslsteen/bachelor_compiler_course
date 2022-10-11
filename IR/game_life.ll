; ModuleID = 'game/game_life.c'
source_filename = "game/game_life.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.field_t = type { [800 x [800 x i8]], i32, i32 }
%struct.cell_t = type { i64, i64 }

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @field_init(%struct.field_t* noundef %0) #0 {
  %2 = alloca %struct.field_t*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca double, align 8
  store %struct.field_t* %0, %struct.field_t** %2, align 8
  %6 = load %struct.field_t*, %struct.field_t** %2, align 8
  %7 = getelementptr inbounds %struct.field_t, %struct.field_t* %6, i32 0, i32 1
  store i32 800, i32* %7, align 4
  %8 = load %struct.field_t*, %struct.field_t** %2, align 8
  %9 = getelementptr inbounds %struct.field_t, %struct.field_t* %8, i32 0, i32 2
  store i32 800, i32* %9, align 4
  store i64 0, i64* %3, align 8
  br label %10

10:                                               ; preds = %43, %1
  %11 = load i64, i64* %3, align 8
  %12 = load %struct.field_t*, %struct.field_t** %2, align 8
  %13 = getelementptr inbounds %struct.field_t, %struct.field_t* %12, i32 0, i32 1
  %14 = load i32, i32* %13, align 4
  %15 = zext i32 %14 to i64
  %16 = icmp ult i64 %11, %15
  br i1 %16, label %17, label %46

17:                                               ; preds = %10
  store i64 0, i64* %4, align 8
  br label %18

18:                                               ; preds = %39, %17
  %19 = load i64, i64* %4, align 8
  %20 = load %struct.field_t*, %struct.field_t** %2, align 8
  %21 = getelementptr inbounds %struct.field_t, %struct.field_t* %20, i32 0, i32 2
  %22 = load i32, i32* %21, align 4
  %23 = zext i32 %22 to i64
  %24 = icmp ult i64 %19, %23
  br i1 %24, label %25, label %42

25:                                               ; preds = %18
  %26 = call i32 @rand() #3
  %27 = sitofp i32 %26 to double
  %28 = fdiv double %27, 0x41DFFFFFFFC00000
  store double %28, double* %5, align 8
  %29 = load double, double* %5, align 8
  %30 = fcmp olt double %29, 1.000000e-01
  %31 = zext i1 %30 to i32
  %32 = trunc i32 %31 to i8
  %33 = load %struct.field_t*, %struct.field_t** %2, align 8
  %34 = getelementptr inbounds %struct.field_t, %struct.field_t* %33, i32 0, i32 0
  %35 = load i64, i64* %4, align 8
  %36 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %34, i64 0, i64 %35
  %37 = load i64, i64* %3, align 8
  %38 = getelementptr inbounds [800 x i8], [800 x i8]* %36, i64 0, i64 %37
  store i8 %32, i8* %38, align 1
  br label %39

39:                                               ; preds = %25
  %40 = load i64, i64* %4, align 8
  %41 = add i64 %40, 1
  store i64 %41, i64* %4, align 8
  br label %18, !llvm.loop !6

42:                                               ; preds = %18
  br label %43

43:                                               ; preds = %42
  %44 = load i64, i64* %3, align 8
  %45 = add i64 %44, 1
  store i64 %45, i64* %3, align 8
  br label %10, !llvm.loop !8

46:                                               ; preds = %10
  ret void
}

; Function Attrs: nounwind
declare i32 @rand() #1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @get_neighbours_num(%struct.field_t* noundef %0, i64 %1, i64 %2) #0 {
  %4 = alloca %struct.cell_t, align 8
  %5 = alloca %struct.field_t*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.cell_t, align 8
  %10 = bitcast %struct.cell_t* %4 to { i64, i64 }*
  %11 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 0
  store i64 %1, i64* %11, align 8
  %12 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 1
  store i64 %2, i64* %12, align 8
  store %struct.field_t* %0, %struct.field_t** %5, align 8
  store i32 0, i32* %6, align 4
  store i32 -1, i32* %7, align 4
  br label %13

13:                                               ; preds = %54, %3
  %14 = load i32, i32* %7, align 4
  %15 = icmp sle i32 %14, 1
  br i1 %15, label %16, label %57

16:                                               ; preds = %13
  store i32 -1, i32* %8, align 4
  br label %17

17:                                               ; preds = %50, %16
  %18 = load i32, i32* %8, align 4
  %19 = icmp sle i32 %18, 1
  br i1 %19, label %20, label %53

20:                                               ; preds = %17
  %21 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %9, i32 0, i32 0
  %22 = load i32, i32* %7, align 4
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %4, i32 0, i32 0
  %25 = load i64, i64* %24, align 8
  %26 = add i64 %23, %25
  store i64 %26, i64* %21, align 8
  %27 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %9, i32 0, i32 1
  %28 = load i32, i32* %8, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %4, i32 0, i32 1
  %31 = load i64, i64* %30, align 8
  %32 = add i64 %29, %31
  store i64 %32, i64* %27, align 8
  %33 = load i32, i32* %7, align 4
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %35, label %39

35:                                               ; preds = %20
  %36 = load i32, i32* %8, align 4
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %39

38:                                               ; preds = %35
  br label %50

39:                                               ; preds = %35, %20
  %40 = load %struct.field_t*, %struct.field_t** %5, align 8
  %41 = bitcast %struct.cell_t* %9 to { i64, i64 }*
  %42 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %41, i32 0, i32 0
  %43 = load i64, i64* %42, align 8
  %44 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %41, i32 0, i32 1
  %45 = load i64, i64* %44, align 8
  %46 = call i32 @get_cell(%struct.field_t* noundef %40, i64 %43, i64 %45)
  %47 = load i32, i32* %6, align 4
  %48 = add nsw i32 %47, %46
  store i32 %48, i32* %6, align 4
  br label %49

49:                                               ; preds = %39
  br label %50

50:                                               ; preds = %49, %38
  %51 = load i32, i32* %8, align 4
  %52 = add nsw i32 %51, 1
  store i32 %52, i32* %8, align 4
  br label %17, !llvm.loop !9

53:                                               ; preds = %17
  br label %54

54:                                               ; preds = %53
  %55 = load i32, i32* %7, align 4
  %56 = add nsw i32 %55, 1
  store i32 %56, i32* %7, align 4
  br label %13, !llvm.loop !10

57:                                               ; preds = %13
  %58 = load i32, i32* %6, align 4
  ret i32 %58
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @get_cell(%struct.field_t* noundef %0, i64 %1, i64 %2) #0 {
  %4 = alloca %struct.cell_t, align 8
  %5 = alloca %struct.field_t*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = bitcast %struct.cell_t* %4 to { i64, i64 }*
  %9 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %8, i32 0, i32 0
  store i64 %1, i64* %9, align 8
  %10 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %8, i32 0, i32 1
  store i64 %2, i64* %10, align 8
  store %struct.field_t* %0, %struct.field_t** %5, align 8
  %11 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %4, i32 0, i32 0
  %12 = load i64, i64* %11, align 8
  %13 = load %struct.field_t*, %struct.field_t** %5, align 8
  %14 = getelementptr inbounds %struct.field_t, %struct.field_t* %13, i32 0, i32 1
  %15 = load i32, i32* %14, align 4
  %16 = zext i32 %15 to i64
  %17 = add i64 %12, %16
  %18 = load %struct.field_t*, %struct.field_t** %5, align 8
  %19 = getelementptr inbounds %struct.field_t, %struct.field_t* %18, i32 0, i32 1
  %20 = load i32, i32* %19, align 4
  %21 = zext i32 %20 to i64
  %22 = urem i64 %17, %21
  %23 = trunc i64 %22 to i32
  store i32 %23, i32* %6, align 4
  %24 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %4, i32 0, i32 1
  %25 = load i64, i64* %24, align 8
  %26 = load %struct.field_t*, %struct.field_t** %5, align 8
  %27 = getelementptr inbounds %struct.field_t, %struct.field_t* %26, i32 0, i32 2
  %28 = load i32, i32* %27, align 4
  %29 = zext i32 %28 to i64
  %30 = add i64 %25, %29
  %31 = load %struct.field_t*, %struct.field_t** %5, align 8
  %32 = getelementptr inbounds %struct.field_t, %struct.field_t* %31, i32 0, i32 2
  %33 = load i32, i32* %32, align 4
  %34 = zext i32 %33 to i64
  %35 = urem i64 %30, %34
  %36 = trunc i64 %35 to i32
  store i32 %36, i32* %7, align 4
  %37 = load %struct.field_t*, %struct.field_t** %5, align 8
  %38 = getelementptr inbounds %struct.field_t, %struct.field_t* %37, i32 0, i32 0
  %39 = load i32, i32* %7, align 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %38, i64 0, i64 %40
  %42 = load i32, i32* %6, align 4
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds [800 x i8], [800 x i8]* %41, i64 0, i64 %43
  %45 = load i8, i8* %44, align 1
  %46 = zext i8 %45 to i32
  ret i32 %46
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @set_cell(%struct.field_t* noundef %0, i64 %1, i64 %2, i32 noundef %3) #0 {
  %5 = alloca %struct.cell_t, align 8
  %6 = alloca %struct.field_t*, align 8
  %7 = alloca i32, align 4
  %8 = bitcast %struct.cell_t* %5 to { i64, i64 }*
  %9 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %8, i32 0, i32 0
  store i64 %1, i64* %9, align 8
  %10 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %8, i32 0, i32 1
  store i64 %2, i64* %10, align 8
  store %struct.field_t* %0, %struct.field_t** %6, align 8
  store i32 %3, i32* %7, align 4
  %11 = load i32, i32* %7, align 4
  %12 = trunc i32 %11 to i8
  %13 = load %struct.field_t*, %struct.field_t** %6, align 8
  %14 = getelementptr inbounds %struct.field_t, %struct.field_t* %13, i32 0, i32 0
  %15 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 1
  %16 = load i64, i64* %15, align 8
  %17 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %14, i64 0, i64 %16
  %18 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 0
  %19 = load i64, i64* %18, align 8
  %20 = getelementptr inbounds [800 x i8], [800 x i8]* %17, i64 0, i64 %19
  store i8 %12, i8* %20, align 1
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @make_next_gen(%struct.field_t* noundef %0, %struct.field_t* noundef %1) #0 {
  %3 = alloca %struct.field_t*, align 8
  %4 = alloca %struct.field_t*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.cell_t, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.field_t* %0, %struct.field_t** %3, align 8
  store %struct.field_t* %1, %struct.field_t** %4, align 8
  store i64 0, i64* %5, align 8
  br label %10

10:                                               ; preds = %72, %2
  %11 = load i64, i64* %5, align 8
  %12 = load %struct.field_t*, %struct.field_t** %3, align 8
  %13 = getelementptr inbounds %struct.field_t, %struct.field_t* %12, i32 0, i32 2
  %14 = load i32, i32* %13, align 4
  %15 = zext i32 %14 to i64
  %16 = icmp ult i64 %11, %15
  br i1 %16, label %17, label %75

17:                                               ; preds = %10
  store i64 0, i64* %6, align 8
  br label %18

18:                                               ; preds = %68, %17
  %19 = load i64, i64* %6, align 8
  %20 = load %struct.field_t*, %struct.field_t** %3, align 8
  %21 = getelementptr inbounds %struct.field_t, %struct.field_t* %20, i32 0, i32 1
  %22 = load i32, i32* %21, align 4
  %23 = zext i32 %22 to i64
  %24 = icmp ult i64 %19, %23
  br i1 %24, label %25, label %71

25:                                               ; preds = %18
  %26 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %7, i32 0, i32 0
  %27 = load i64, i64* %6, align 8
  store i64 %27, i64* %26, align 8
  %28 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %7, i32 0, i32 1
  %29 = load i64, i64* %5, align 8
  store i64 %29, i64* %28, align 8
  store i32 2, i32* %8, align 4
  %30 = load %struct.field_t*, %struct.field_t** %3, align 8
  %31 = bitcast %struct.cell_t* %7 to { i64, i64 }*
  %32 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %31, i32 0, i32 0
  %33 = load i64, i64* %32, align 8
  %34 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %31, i32 0, i32 1
  %35 = load i64, i64* %34, align 8
  %36 = call i32 @get_neighbours_num(%struct.field_t* noundef %30, i64 %33, i64 %35)
  store i32 %36, i32* %9, align 4
  %37 = load %struct.field_t*, %struct.field_t** %3, align 8
  %38 = bitcast %struct.cell_t* %7 to { i64, i64 }*
  %39 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %38, i32 0, i32 0
  %40 = load i64, i64* %39, align 8
  %41 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %38, i32 0, i32 1
  %42 = load i64, i64* %41, align 8
  %43 = call i32 @get_cell(%struct.field_t* noundef %37, i64 %40, i64 %42)
  %44 = icmp ne i32 %43, 0
  br i1 %44, label %45, label %54

45:                                               ; preds = %25
  %46 = load i32, i32* %9, align 4
  %47 = icmp eq i32 %46, 2
  br i1 %47, label %51, label %48

48:                                               ; preds = %45
  %49 = load i32, i32* %9, align 4
  %50 = icmp eq i32 %49, 3
  br i1 %50, label %51, label %52

51:                                               ; preds = %48, %45
  store i32 1, i32* %8, align 4
  br label %53

52:                                               ; preds = %48
  store i32 0, i32* %8, align 4
  br label %53

53:                                               ; preds = %52, %51
  br label %60

54:                                               ; preds = %25
  %55 = load i32, i32* %9, align 4
  %56 = icmp eq i32 %55, 3
  br i1 %56, label %57, label %58

57:                                               ; preds = %54
  store i32 1, i32* %8, align 4
  br label %59

58:                                               ; preds = %54
  store i32 0, i32* %8, align 4
  br label %59

59:                                               ; preds = %58, %57
  br label %60

60:                                               ; preds = %59, %53
  %61 = load %struct.field_t*, %struct.field_t** %4, align 8
  %62 = load i32, i32* %8, align 4
  %63 = bitcast %struct.cell_t* %7 to { i64, i64 }*
  %64 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %63, i32 0, i32 0
  %65 = load i64, i64* %64, align 8
  %66 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %63, i32 0, i32 1
  %67 = load i64, i64* %66, align 8
  call void @set_cell(%struct.field_t* noundef %61, i64 %65, i64 %67, i32 noundef %62)
  br label %68

68:                                               ; preds = %60
  %69 = load i64, i64* %6, align 8
  %70 = add i64 %69, 1
  store i64 %70, i64* %6, align 8
  br label %18, !llvm.loop !11

71:                                               ; preds = %18
  br label %72

72:                                               ; preds = %71
  %73 = load i64, i64* %5, align 8
  %74 = add i64 %73, 1
  store i64 %74, i64* %5, align 8
  br label %10, !llvm.loop !12

75:                                               ; preds = %10
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @draw_field(%struct.field_t* noundef %0) #0 {
  %2 = alloca %struct.field_t*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.cell_t, align 8
  store %struct.field_t* %0, %struct.field_t** %2, align 8
  store i64 0, i64* %3, align 8
  br label %6

6:                                                ; preds = %53, %1
  %7 = load i64, i64* %3, align 8
  %8 = load %struct.field_t*, %struct.field_t** %2, align 8
  %9 = getelementptr inbounds %struct.field_t, %struct.field_t* %8, i32 0, i32 1
  %10 = load i32, i32* %9, align 4
  %11 = zext i32 %10 to i64
  %12 = icmp ult i64 %7, %11
  br i1 %12, label %13, label %56

13:                                               ; preds = %6
  store i64 0, i64* %4, align 8
  br label %14

14:                                               ; preds = %49, %13
  %15 = load i64, i64* %4, align 8
  %16 = load %struct.field_t*, %struct.field_t** %2, align 8
  %17 = getelementptr inbounds %struct.field_t, %struct.field_t* %16, i32 0, i32 2
  %18 = load i32, i32* %17, align 4
  %19 = zext i32 %18 to i64
  %20 = icmp ult i64 %15, %19
  br i1 %20, label %21, label %52

21:                                               ; preds = %14
  %22 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 0
  %23 = load i64, i64* %3, align 8
  store i64 %23, i64* %22, align 8
  %24 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 1
  %25 = load i64, i64* %4, align 8
  store i64 %25, i64* %24, align 8
  %26 = load %struct.field_t*, %struct.field_t** %2, align 8
  %27 = bitcast %struct.cell_t* %5 to { i64, i64 }*
  %28 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %27, i32 0, i32 0
  %29 = load i64, i64* %28, align 8
  %30 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %27, i32 0, i32 1
  %31 = load i64, i64* %30, align 8
  %32 = call i32 @get_cell(%struct.field_t* noundef %26, i64 %29, i64 %31)
  switch i32 %32, label %47 [
    i32 1, label %33
    i32 0, label %40
  ]

33:                                               ; preds = %21
  %34 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 0
  %35 = load i64, i64* %34, align 8
  %36 = trunc i64 %35 to i32
  %37 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 1
  %38 = load i64, i64* %37, align 8
  %39 = trunc i64 %38 to i32
  call void @set_pixel(i32 noundef %36, i32 noundef %39, i8 noundef zeroext 0, i8 noundef zeroext -1, i8 noundef zeroext 0)
  br label %48

40:                                               ; preds = %21
  %41 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 0
  %42 = load i64, i64* %41, align 8
  %43 = trunc i64 %42 to i32
  %44 = getelementptr inbounds %struct.cell_t, %struct.cell_t* %5, i32 0, i32 1
  %45 = load i64, i64* %44, align 8
  %46 = trunc i64 %45 to i32
  call void @set_pixel(i32 noundef %43, i32 noundef %46, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0)
  br label %48

47:                                               ; preds = %21
  br label %48

48:                                               ; preds = %47, %40, %33
  br label %49

49:                                               ; preds = %48
  %50 = load i64, i64* %4, align 8
  %51 = add i64 %50, 1
  store i64 %51, i64* %4, align 8
  br label %14, !llvm.loop !13

52:                                               ; preds = %14
  br label %53

53:                                               ; preds = %52
  %54 = load i64, i64* %3, align 8
  %55 = add i64 %54, 1
  store i64 %55, i64* %3, align 8
  br label %6, !llvm.loop !14

56:                                               ; preds = %6
  ret void
}

declare void @set_pixel(i32 noundef, i32 noundef, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) #2

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @swap(%struct.field_t* noundef %0, %struct.field_t* noundef %1) #0 {
  %3 = alloca %struct.field_t*, align 8
  %4 = alloca %struct.field_t*, align 8
  %5 = alloca i8, align 1
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.field_t* %0, %struct.field_t** %3, align 8
  store %struct.field_t* %1, %struct.field_t** %4, align 8
  store i8 0, i8* %5, align 1
  store i64 0, i64* %6, align 8
  br label %8

8:                                                ; preds = %55, %2
  %9 = load i64, i64* %6, align 8
  %10 = load %struct.field_t*, %struct.field_t** %3, align 8
  %11 = getelementptr inbounds %struct.field_t, %struct.field_t* %10, i32 0, i32 1
  %12 = load i32, i32* %11, align 4
  %13 = zext i32 %12 to i64
  %14 = icmp ult i64 %9, %13
  br i1 %14, label %15, label %58

15:                                               ; preds = %8
  store i64 0, i64* %7, align 8
  br label %16

16:                                               ; preds = %51, %15
  %17 = load i64, i64* %7, align 8
  %18 = load %struct.field_t*, %struct.field_t** %3, align 8
  %19 = getelementptr inbounds %struct.field_t, %struct.field_t* %18, i32 0, i32 2
  %20 = load i32, i32* %19, align 4
  %21 = zext i32 %20 to i64
  %22 = icmp ult i64 %17, %21
  br i1 %22, label %23, label %54

23:                                               ; preds = %16
  %24 = load %struct.field_t*, %struct.field_t** %4, align 8
  %25 = getelementptr inbounds %struct.field_t, %struct.field_t* %24, i32 0, i32 0
  %26 = load i64, i64* %7, align 8
  %27 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %25, i64 0, i64 %26
  %28 = load i64, i64* %6, align 8
  %29 = getelementptr inbounds [800 x i8], [800 x i8]* %27, i64 0, i64 %28
  %30 = load i8, i8* %29, align 1
  store i8 %30, i8* %5, align 1
  %31 = load %struct.field_t*, %struct.field_t** %4, align 8
  %32 = getelementptr inbounds %struct.field_t, %struct.field_t* %31, i32 0, i32 0
  %33 = load i64, i64* %7, align 8
  %34 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %32, i64 0, i64 %33
  %35 = load i64, i64* %6, align 8
  %36 = getelementptr inbounds [800 x i8], [800 x i8]* %34, i64 0, i64 %35
  %37 = load i8, i8* %36, align 1
  %38 = load %struct.field_t*, %struct.field_t** %3, align 8
  %39 = getelementptr inbounds %struct.field_t, %struct.field_t* %38, i32 0, i32 0
  %40 = load i64, i64* %7, align 8
  %41 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %39, i64 0, i64 %40
  %42 = load i64, i64* %6, align 8
  %43 = getelementptr inbounds [800 x i8], [800 x i8]* %41, i64 0, i64 %42
  store i8 %37, i8* %43, align 1
  %44 = load i8, i8* %5, align 1
  %45 = load %struct.field_t*, %struct.field_t** %4, align 8
  %46 = getelementptr inbounds %struct.field_t, %struct.field_t* %45, i32 0, i32 0
  %47 = load i64, i64* %7, align 8
  %48 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* %46, i64 0, i64 %47
  %49 = load i64, i64* %6, align 8
  %50 = getelementptr inbounds [800 x i8], [800 x i8]* %48, i64 0, i64 %49
  store i8 %44, i8* %50, align 1
  br label %51

51:                                               ; preds = %23
  %52 = load i64, i64* %7, align 8
  %53 = add i64 %52, 1
  store i64 %53, i64* %7, align 8
  br label %16, !llvm.loop !15

54:                                               ; preds = %16
  br label %55

55:                                               ; preds = %54
  %56 = load i64, i64* %6, align 8
  %57 = add i64 %56, 1
  store i64 %57, i64* %6, align 8
  br label %8, !llvm.loop !16

58:                                               ; preds = %8
  ret void
}

attributes #0 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
