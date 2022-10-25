; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.field_t = type { [800 x [800 x i8]], i32, i32 }

@main_field = dso_local global %struct.field_t zeroinitializer, align 4
@tmp_field = dso_local global %struct.field_t zeroinitializer, align 4

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @field_init(%struct.field_t* nocapture noundef %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 1
  store i32 800, i32* %2, align 4, !tbaa !5
  %3 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 2
  store i32 800, i32* %3, align 4, !tbaa !10
  br label %4

4:                                                ; preds = %1, %9
  %5 = phi i64 [ %10, %9 ], [ 0, %1 ]
  %6 = load i32, i32* %3, align 4, !tbaa !10
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %9, label %14

8:                                                ; preds = %9
  ret void

9:                                                ; preds = %14, %4
  %10 = add nuw nsw i64 %5, 1
  %11 = load i32, i32* %2, align 4, !tbaa !5
  %12 = zext i32 %11 to i64
  %13 = icmp ult i64 %10, %12
  br i1 %13, label %4, label %8, !llvm.loop !11

14:                                               ; preds = %4, %14
  %15 = phi i64 [ %22, %14 ], [ 0, %4 ]
  %16 = call i32 @rand() #10
  %17 = sitofp i32 %16 to double
  %18 = fdiv double %17, 0x41DFFFFFFFC00000
  %19 = fcmp olt double %18, 1.000000e-01
  %20 = zext i1 %19 to i8
  %21 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %15, i64 %5
  store i8 %20, i8* %21, align 1, !tbaa !14
  %22 = add nuw nsw i64 %15, 1
  %23 = load i32, i32* %3, align 4, !tbaa !10
  %24 = zext i32 %23 to i64
  %25 = icmp ult i64 %22, %24
  br i1 %25, label %14, label %9, !llvm.loop !15
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind
declare i32 @rand() local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly sspstrong uwtable willreturn
define dso_local i32 @get_cell(%struct.field_t* nocapture noundef readonly %0, i64 %1, i64 %2) local_unnamed_addr #3 {
  %4 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !5
  %6 = zext i32 %5 to i64
  %7 = add i64 %6, %1
  %8 = urem i64 %7, %6
  %9 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 2
  %10 = load i32, i32* %9, align 4, !tbaa !10
  %11 = zext i32 %10 to i64
  %12 = add i64 %11, %2
  %13 = urem i64 %12, %11
  %14 = shl nuw i64 %13, 32
  %15 = ashr exact i64 %14, 32
  %16 = shl nuw i64 %8, 32
  %17 = ashr exact i64 %16, 32
  %18 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %15, i64 %17
  %19 = load i8, i8* %18, align 1, !tbaa !14
  %20 = zext i8 %19 to i32
  ret i32 %20
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong uwtable willreturn writeonly
define dso_local void @set_cell(%struct.field_t* nocapture noundef writeonly %0, i64 %1, i64 %2, i32 noundef %3) local_unnamed_addr #4 {
  %5 = trunc i32 %3 to i8
  %6 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %2, i64 %1
  store i8 %5, i8* %6, align 1, !tbaa !14
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind readonly sspstrong uwtable
define dso_local i32 @get_neighbours_num(%struct.field_t* nocapture noundef readonly %0, i64 %1, i64 %2) local_unnamed_addr #5 {
  %4 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 1
  %5 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 2
  br label %6

6:                                                ; preds = %3, %12
  %7 = phi i64 [ -1, %3 ], [ %13, %12 ]
  %8 = phi i32 [ 0, %3 ], [ %39, %12 ]
  %9 = icmp eq i64 %7, 0
  %10 = add i64 %7, %1
  br label %15

11:                                               ; preds = %12
  ret i32 %39

12:                                               ; preds = %38
  %13 = add nsw i64 %7, 1
  %14 = icmp eq i64 %13, 2
  br i1 %14, label %11, label %6, !llvm.loop !16

15:                                               ; preds = %6, %38
  %16 = phi i64 [ -1, %6 ], [ %40, %38 ]
  %17 = phi i32 [ %8, %6 ], [ %39, %38 ]
  %18 = icmp eq i64 %16, 0
  %19 = select i1 %9, i1 %18, i1 false
  br i1 %19, label %38, label %20

20:                                               ; preds = %15
  %21 = add i64 %16, %2
  %22 = load i32, i32* %4, align 4, !tbaa !5
  %23 = zext i32 %22 to i64
  %24 = add i64 %10, %23
  %25 = urem i64 %24, %23
  %26 = load i32, i32* %5, align 4, !tbaa !10
  %27 = zext i32 %26 to i64
  %28 = add i64 %21, %27
  %29 = urem i64 %28, %27
  %30 = shl nuw i64 %29, 32
  %31 = ashr exact i64 %30, 32
  %32 = shl nuw i64 %25, 32
  %33 = ashr exact i64 %32, 32
  %34 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %31, i64 %33
  %35 = load i8, i8* %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i32
  %37 = add nsw i32 %17, %36
  br label %38

38:                                               ; preds = %15, %20
  %39 = phi i32 [ %37, %20 ], [ %17, %15 ]
  %40 = add nsw i64 %16, 1
  %41 = icmp eq i64 %40, 2
  br i1 %41, label %12, label %15, !llvm.loop !17
}

; Function Attrs: nofree norecurse nosync nounwind sspstrong uwtable
define dso_local void @make_next_gen(%struct.field_t* nocapture noundef readonly %0, %struct.field_t* nocapture noundef writeonly %1) local_unnamed_addr #6 {
  %3 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 2
  %4 = load i32, i32* %3, align 4, !tbaa !10
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %14, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 1
  br label %8

8:                                                ; preds = %6, %19
  %9 = phi i64 [ 0, %6 ], [ %20, %19 ]
  %10 = load i32, i32* %7, align 4, !tbaa !5
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %19, label %12

12:                                               ; preds = %8
  %13 = zext i32 %10 to i64
  br label %15

14:                                               ; preds = %19, %2
  ret void

15:                                               ; preds = %12, %56
  %16 = phi i64 [ %78, %56 ], [ %13, %12 ]
  %17 = phi i64 [ %76, %56 ], [ 0, %12 ]
  %18 = add nuw i64 %16, %17
  br label %24

19:                                               ; preds = %56, %8
  %20 = add nuw nsw i64 %9, 1
  %21 = load i32, i32* %3, align 4, !tbaa !10
  %22 = zext i32 %21 to i64
  %23 = icmp ult i64 %20, %22
  br i1 %23, label %8, label %14, !llvm.loop !18

24:                                               ; preds = %15, %29
  %25 = phi i64 [ %30, %29 ], [ -1, %15 ]
  %26 = phi i32 [ %53, %29 ], [ 0, %15 ]
  %27 = icmp eq i64 %25, 0
  %28 = add i64 %18, %25
  br label %32

29:                                               ; preds = %52
  %30 = add nsw i64 %25, 1
  %31 = icmp eq i64 %30, 2
  br i1 %31, label %56, label %24, !llvm.loop !16

32:                                               ; preds = %52, %24
  %33 = phi i64 [ -1, %24 ], [ %54, %52 ]
  %34 = phi i32 [ %26, %24 ], [ %53, %52 ]
  %35 = icmp eq i64 %33, 0
  %36 = select i1 %27, i1 %35, i1 false
  br i1 %36, label %52, label %37

37:                                               ; preds = %32
  %38 = add nsw i64 %33, %9
  %39 = urem i64 %28, %16
  %40 = load i32, i32* %3, align 4, !tbaa !10
  %41 = zext i32 %40 to i64
  %42 = add i64 %38, %41
  %43 = urem i64 %42, %41
  %44 = shl nuw i64 %43, 32
  %45 = ashr exact i64 %44, 32
  %46 = shl nuw i64 %39, 32
  %47 = ashr exact i64 %46, 32
  %48 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %45, i64 %47
  %49 = load i8, i8* %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i32
  %51 = add nsw i32 %34, %50
  br label %52

52:                                               ; preds = %37, %32
  %53 = phi i32 [ %51, %37 ], [ %34, %32 ]
  %54 = add nsw i64 %33, 1
  %55 = icmp eq i64 %54, 2
  br i1 %55, label %29, label %32, !llvm.loop !17

56:                                               ; preds = %29
  %57 = add nuw i64 %16, %17
  %58 = urem i64 %57, %16
  %59 = load i32, i32* %3, align 4, !tbaa !10
  %60 = zext i32 %59 to i64
  %61 = add nuw i64 %9, %60
  %62 = urem i64 %61, %60
  %63 = shl nuw i64 %62, 32
  %64 = ashr exact i64 %63, 32
  %65 = shl nuw i64 %58, 32
  %66 = ashr exact i64 %65, 32
  %67 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %64, i64 %66
  %68 = load i8, i8* %67, align 1, !tbaa !14
  %69 = icmp eq i8 %68, 0
  %70 = and i32 %53, -2
  %71 = icmp eq i32 %70, 2
  %72 = icmp eq i32 %53, 3
  %73 = select i1 %69, i1 %72, i1 %71
  %74 = zext i1 %73 to i8
  %75 = getelementptr inbounds %struct.field_t, %struct.field_t* %1, i64 0, i32 0, i64 %9, i64 %17
  store i8 %74, i8* %75, align 1, !tbaa !14
  %76 = add nuw nsw i64 %17, 1
  %77 = load i32, i32* %7, align 4, !tbaa !5
  %78 = zext i32 %77 to i64
  %79 = icmp ult i64 %76, %78
  br i1 %79, label %15, label %19, !llvm.loop !19
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @draw_field(%struct.field_t* nocapture noundef readonly %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 1
  %3 = load i32, i32* %2, align 4, !tbaa !5
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %15, label %5

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 2
  br label %7

7:                                                ; preds = %5, %16
  %8 = phi i64 [ 0, %5 ], [ %17, %16 ]
  %9 = load i32, i32* %6, align 4, !tbaa !10
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %16, label %11

11:                                               ; preds = %7
  %12 = zext i32 %9 to i64
  %13 = trunc i64 %8 to i32
  %14 = trunc i64 %8 to i32
  br label %21

15:                                               ; preds = %16, %1
  ret void

16:                                               ; preds = %40, %7
  %17 = add nuw nsw i64 %8, 1
  %18 = load i32, i32* %2, align 4, !tbaa !5
  %19 = zext i32 %18 to i64
  %20 = icmp ult i64 %17, %19
  br i1 %20, label %7, label %15, !llvm.loop !20

21:                                               ; preds = %11, %40
  %22 = phi i64 [ %12, %11 ], [ %43, %40 ]
  %23 = phi i64 [ 0, %11 ], [ %41, %40 ]
  %24 = load i32, i32* %2, align 4, !tbaa !5
  %25 = zext i32 %24 to i64
  %26 = add nuw i64 %8, %25
  %27 = urem i64 %26, %25
  %28 = add nuw i64 %22, %23
  %29 = urem i64 %28, %22
  %30 = shl nuw i64 %29, 32
  %31 = ashr exact i64 %30, 32
  %32 = shl nuw i64 %27, 32
  %33 = ashr exact i64 %32, 32
  %34 = getelementptr inbounds %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 %31, i64 %33
  %35 = load i8, i8* %34, align 1, !tbaa !14
  switch i8 %35, label %40 [
    i8 1, label %36
    i8 0, label %38
  ]

36:                                               ; preds = %21
  %37 = trunc i64 %23 to i32
  call void @set_pixel(i32 noundef %14, i32 noundef %37, i8 noundef zeroext 0, i8 noundef zeroext -1, i8 noundef zeroext 0) #10
  br label %40

38:                                               ; preds = %21
  %39 = trunc i64 %23 to i32
  call void @set_pixel(i32 noundef %13, i32 noundef %39, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0) #10
  br label %40

40:                                               ; preds = %21, %38, %36
  %41 = add nuw nsw i64 %23, 1
  %42 = load i32, i32* %6, align 4, !tbaa !10
  %43 = zext i32 %42 to i64
  %44 = icmp ult i64 %41, %43
  br i1 %44, label %21, label %16, !llvm.loop !21
}

declare void @set_pixel(i32 noundef, i32 noundef, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) local_unnamed_addr #7

; Function Attrs: mustprogress nofree nosync nounwind sspstrong uwtable willreturn
define dso_local void @swap(%struct.field_t* nocapture noundef %0, %struct.field_t* nocapture noundef %1) local_unnamed_addr #8 {
  %3 = alloca %struct.field_t, align 4
  %4 = getelementptr inbounds %struct.field_t, %struct.field_t* %3, i64 0, i32 0, i64 0, i64 0
  %5 = getelementptr inbounds %struct.field_t, %struct.field_t* %3, i64 0, i32 0, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 640008, i8* nonnull %5)
  %6 = getelementptr %struct.field_t, %struct.field_t* %0, i64 0, i32 0, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(640008) %4, i8* noundef nonnull align 4 dereferenceable(640008) %6, i64 640008, i1 false), !tbaa.struct !22
  %7 = getelementptr %struct.field_t, %struct.field_t* %1, i64 0, i32 0, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(640008) %6, i8* noundef nonnull align 4 dereferenceable(640008) %7, i64 640008, i1 false), !tbaa.struct !22
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(640008) %7, i8* noundef nonnull align 4 dereferenceable(640008) %4, i64 640008, i1 false), !tbaa.struct !22
  %8 = getelementptr inbounds %struct.field_t, %struct.field_t* %3, i64 0, i32 0, i64 0, i64 0
  call void @llvm.lifetime.end.p0i8(i64 640008, i8* nonnull %8)
  ret void
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #9

; Function Attrs: nounwind sspstrong uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca %struct.field_t, align 4
  call void (...) @graph_init() #10
  store i32 800, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 1), align 4, !tbaa !5
  store i32 800, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 2), align 4, !tbaa !10
  br label %2

2:                                                ; preds = %6, %0
  %3 = phi i64 [ %7, %6 ], [ 0, %0 ]
  %4 = load i32, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 2), align 4, !tbaa !10
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %11

6:                                                ; preds = %11, %2
  %7 = add nuw nsw i64 %3, 1
  %8 = load i32, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 1), align 4, !tbaa !5
  %9 = zext i32 %8 to i64
  %10 = icmp ult i64 %7, %9
  br i1 %10, label %2, label %23, !llvm.loop !11

11:                                               ; preds = %2, %11
  %12 = phi i64 [ %19, %11 ], [ 0, %2 ]
  %13 = call i32 @rand() #10
  %14 = sitofp i32 %13 to double
  %15 = fdiv double %14, 0x41DFFFFFFFC00000
  %16 = fcmp olt double %15, 1.000000e-01
  %17 = zext i1 %16 to i8
  %18 = getelementptr inbounds %struct.field_t, %struct.field_t* @main_field, i64 0, i32 0, i64 %12, i64 %3
  store i8 %17, i8* %18, align 1, !tbaa !14
  %19 = add nuw nsw i64 %12, 1
  %20 = load i32, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 2), align 4, !tbaa !10
  %21 = zext i32 %20 to i64
  %22 = icmp ult i64 %19, %21
  br i1 %22, label %11, label %6, !llvm.loop !15

23:                                               ; preds = %6
  store i32 800, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 1), align 4, !tbaa !5
  store i32 800, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 2), align 4, !tbaa !10
  br label %24

24:                                               ; preds = %28, %23
  %25 = phi i64 [ %29, %28 ], [ 0, %23 ]
  %26 = load i32, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 2), align 4, !tbaa !10
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %39

28:                                               ; preds = %39, %24
  %29 = add nuw nsw i64 %25, 1
  %30 = load i32, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 1), align 4, !tbaa !5
  %31 = zext i32 %30 to i64
  %32 = icmp ult i64 %29, %31
  br i1 %32, label %24, label %33, !llvm.loop !11

33:                                               ; preds = %28
  %34 = call zeroext i1 (...) @is_open_window() #10
  br i1 %34, label %35, label %53

35:                                               ; preds = %33
  %36 = getelementptr inbounds %struct.field_t, %struct.field_t* %1, i64 0, i32 0, i64 0, i64 0
  %37 = getelementptr inbounds %struct.field_t, %struct.field_t* %1, i64 0, i32 0, i64 0, i64 0
  %38 = getelementptr inbounds %struct.field_t, %struct.field_t* %1, i64 0, i32 0, i64 0, i64 0
  br label %51

39:                                               ; preds = %24, %39
  %40 = phi i64 [ %47, %39 ], [ 0, %24 ]
  %41 = call i32 @rand() #10
  %42 = sitofp i32 %41 to double
  %43 = fdiv double %42, 0x41DFFFFFFFC00000
  %44 = fcmp olt double %43, 1.000000e-01
  %45 = zext i1 %44 to i8
  %46 = getelementptr inbounds %struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 0, i64 %40, i64 %25
  store i8 %45, i8* %46, align 1, !tbaa !14
  %47 = add nuw nsw i64 %40, 1
  %48 = load i32, i32* getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 2), align 4, !tbaa !10
  %49 = zext i32 %48 to i64
  %50 = icmp ult i64 %47, %49
  br i1 %50, label %39, label %28, !llvm.loop !15

51:                                               ; preds = %35, %51
  call void @window_clear(i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0) #10
  call void @make_next_gen(%struct.field_t* noundef nonnull @main_field, %struct.field_t* noundef nonnull @tmp_field)
  call void @draw_field(%struct.field_t* noundef nonnull @main_field)
  call void @llvm.lifetime.start.p0i8(i64 640008, i8* nonnull %37)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(640008) %36, i8* noundef nonnull align 4 dereferenceable(640008) getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 0, i64 0, i64 0), i64 640008, i1 false) #10, !tbaa.struct !22
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(640008) getelementptr inbounds (%struct.field_t, %struct.field_t* @main_field, i64 0, i32 0, i64 0, i64 0), i8* noundef nonnull align 4 dereferenceable(640008) getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 0, i64 0, i64 0), i64 640008, i1 false) #10, !tbaa.struct !22
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(640008) getelementptr inbounds (%struct.field_t, %struct.field_t* @tmp_field, i64 0, i32 0, i64 0, i64 0), i8* noundef nonnull align 4 dereferenceable(640008) %36, i64 640008, i1 false) #10, !tbaa.struct !22
  call void @llvm.lifetime.end.p0i8(i64 640008, i8* nonnull %38)
  call void (...) @flush() #10
  %52 = call zeroext i1 (...) @is_open_window() #10
  br i1 %52, label %51, label %53, !llvm.loop !24

53:                                               ; preds = %51, %33
  ret i32 0
}

declare void @graph_init(...) local_unnamed_addr #7

declare zeroext i1 @is_open_window(...) local_unnamed_addr #7

declare void @window_clear(i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) local_unnamed_addr #7

declare void @flush(...) local_unnamed_addr #7

attributes #0 = { nounwind sspstrong uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind readonly sspstrong uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree norecurse nosync nounwind sspstrong uwtable willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree norecurse nosync nounwind readonly sspstrong uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree norecurse nosync nounwind sspstrong uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { mustprogress nofree nosync nounwind sspstrong uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #10 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"clang version 14.0.6"}
!5 = !{!6, !9, i64 640000}
!6 = !{!"field_t", !7, i64 0, !9, i64 640000, !9, i64 640004}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"int", !7, i64 0}
!10 = !{!6, !9, i64 640004}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = !{!7, !7, i64 0}
!15 = distinct !{!15, !12, !13}
!16 = distinct !{!16, !12, !13}
!17 = distinct !{!17, !12, !13}
!18 = distinct !{!18, !12, !13}
!19 = distinct !{!19, !12, !13}
!20 = distinct !{!20, !12, !13}
!21 = distinct !{!21, !12, !13}
!22 = !{i64 0, i64 640000, !14, i64 640000, i64 4, !23, i64 640004, i64 4, !23}
!23 = !{!9, !9, i64 0}
!24 = distinct !{!24, !12, !13}
