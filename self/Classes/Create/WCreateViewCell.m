//
//  WTopicCollectionViewCell.m
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "WCreateViewCell.h"
#import "UIViewAdditions.h"
#import "ImageUtils.h"
#import "SevenSwitch.h"
#import "WUserUtils.h"

@interface WCreateViewCell()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation WCreateViewCell

-(void)setImageCamera:(blockPhotoCamera)photoCamera
{
    UIImage* image = photoCamera(self);
    self.imageView.image = image;
}

- (IBAction)clickPhotoCamera:(id)sender {
    
    //设置为相机,否则拍照完后,跳转到Nav时,又重新加载了.
    [[WUserUtils sharedWUserUtils]setIsCameraOrPhoto:YES];
    self.didClickPhotoCamera(self);
//    self.imageView.image = image;
    

}

-(IBAction)clickPhotoSelect:(id)sender
{
    //设置为相机,否则拍照完后,跳转到Nav时,又重新加载了.
    [[WUserUtils sharedWUserUtils]setIsCameraOrPhoto:YES];
    
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [mediatypes count]>0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing=YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)clickPhotoDelete:(id)sender {
}


-(void)awakeFromNib
{
   // [self addSwitch];
    self.titleLabel.hidden=YES;
    
    [self.titleLabel setupInit:@""];
    
    self.btnPhotoDelete.hidden=YES;
    self.imageView.image = [[ImageUtils sharedImageUtils]imageWithColor:[UIColor grayColor]];
    
    self.textField.delegate=self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.uiSwitch addTarget:self action:@selector(didClickSwitch:) forControlEvents:UIControlEventValueChanged];
 
}



-(void)addSwitch
{
    SevenSwitch *sw2 = [[SevenSwitch alloc]initWithFrame:CGRectMake(232, 189, 65, 31)];
    //sw2.thumbImage=[UIImage imageNamed:@"create_middle_selected.png"];
    sw2.offLabel.text=@"下方";
    sw2.offLabel.textAlignment=NSTextAlignmentLeft;
    sw2.onLabel.text=@"居中";
    sw2.onLabel.textColor=UIColorFromRGB(0xFFFFFF);
    sw2.onLabel.textAlignment=NSTextAlignmentRight;
    sw2.isRounded=YES;
    sw2.inactiveColor=UIColorFromRGB(0xFFFFFF);
    sw2.onTintColor=UIColorFromRGB(0x900D21);
    [self  addSubview:sw2];
}

-(void)textFieldDidChange:(id)sender
{
    UITextField *txt = (UITextField *)sender;
 
    NSString* text =txt.text;
    if (![@"" isEqualToString:text]) {
        self.titleLabel.hidden=NO;
    }else{
        self.titleLabel.hidden=YES;
    }
    
    [self.titleLabel  setTitle:text];
 
}

-(void)didClickSwitch:(id)sender
{
    UISwitch *switch0 = (UISwitch *)sender;
    if (switch0.on) {
        [self.titleLabel setTop:self.imageView.height/2 ];
    }else{
        [self.titleLabel setTop:self.imageView.height - self.titleLabel.height];
    }
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.didTextfieldShow(self);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.didTextfieldHidden(self);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //UIImagePickerControllerEditedImage
    UIImage *image1=[info objectForKey:UIImagePickerControllerEditedImage];
    
    //imageView.image = [self imageWithImageSimple:image0 scaledToSize:CGSizeMake(640, 640)];
    self.imageView.image = image1;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //    NSString *mediaType = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    if ([mediaType isEqualToString:@"public.image"]) {
    //        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //        NSData *data;
    //        //        if (UIImagePNGRepresentation(image)==nil) {
    //        //            data=UIImageJPEGRepresentation(image, 1);
    //        //        }else{
    //        //
    //        //
    //        //            data=UIImagePNGRepresentation(image);
    //        //        }
    //        data=UIImageJPEGRepresentation(image, 0.5);
    //
    //        NSFileManager *fileManager=[NSFileManager defaultManager];
    //        NSString* filePath =@"/what";
    //        [fileManager createDirectoryAtPath:filePath
    //               withIntermediateDirectories:YES
    //                                attributes:nil
    //                                     error:nil];
    //        [fileManager createFileAtPath:[filePath stringByAppendingString:imageName]
    //                             contents:data
    //                           attributes:nil];
    //
    //        UIImage *editedimage =[[UIImage alloc]init];
    //        editedimage=image;
    //        CGRect rect=CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    //        UIGraphicsBeginImageContext(rect.size);
    //        [editedimage drawInRect:rect];
    //        editedimage =UIGraphicsGetImageFromCurrentImageContext();
    //        imageView.image =image;
    //        
    //        [picker dismissViewControllerAnimated:YES completion:nil];
    //    }
    
    
}


@end