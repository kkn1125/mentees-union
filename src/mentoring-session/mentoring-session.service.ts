import { Injectable } from '@nestjs/common';
import { CreateMentoringSessionDto } from './dto/create-mentoring-session.dto';
import { UpdateMentoringSessionDto } from './dto/update-mentoring-session.dto';
import { MentoringSession } from './entities/mentoring-session.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ApiResponseService } from '@/api-response/api-response.service';

@Injectable()
export class MentoringSessionService {
  constructor(
    @InjectRepository(MentoringSession)
    private readonly mentoringSessionRepository: Repository<MentoringSession>,
  ) {}

  findAll() {
    return this.mentoringSessionRepository.find();
  }

  findAllByUser(user_id: number) {
    return this.mentoringSessionRepository.find({
      where: { mentorings: { mentee_id: user_id } },
      relations: {
        mentorings: true,
        messages: true,
        category: true,
      },
    });
  }

  async findOne(id: number) {
    try {
      return await this.mentoringSessionRepository.findOneOrFail({
        where: { id },
        relations: {
          mentorings: true,
          messages: true,
          category: true,
        },
      });
    } catch (error) {
      ApiResponseService.NOT_FOUND(error, `not found mentoring session ${id}`);
    }
  }

  async create(createMentoringDto: CreateMentoringSessionDto) {
    const qr =
      this.mentoringSessionRepository.manager.connection.createQueryRunner();

    await qr.startTransaction();

    try {
      const dto = await this.mentoringSessionRepository.save(
        createMentoringDto,
        {
          transaction: true,
        },
      );
      console.log('mentoringsession dto', dto);
      await qr.commitTransaction();
      await qr.release();
      return dto;
    } catch (error) {
      await qr.rollbackTransaction();
      await qr.release();
      ApiResponseService.BAD_REQUEST(error, 'fail create mentoring session');
    }
  }

  async update(id: number, updateMentoringDto: UpdateMentoringSessionDto) {
    const qr =
      this.mentoringSessionRepository.manager.connection.createQueryRunner();
    await this.findOne(id);

    await qr.startTransaction();
    try {
      const dto = await this.mentoringSessionRepository.update(
        id,
        updateMentoringDto,
      );
      await qr.commitTransaction();
      await qr.release();
    } catch (error) {
      await qr.rollbackTransaction();
      await qr.release();
      ApiResponseService.BAD_REQUEST(error, 'fail update mentoring session');
    }
  }

  async remove(id: number) {
    await this.findOne(id);
    return this.mentoringSessionRepository.softDelete({ id });
  }

  async restore(id: number) {
    await this.findOne(id);
    return this.mentoringSessionRepository.restore({ id });
  }

  createChannel() {
    // channel create logics...
  }
}
