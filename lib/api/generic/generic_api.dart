import 'package:shelf_plus/shelf_plus.dart';

import '../../marshall/data_type_marshall.dart';
import '../../service/generic/generic_service.dart';

class GenericAPI<T> {
  RouterPlus router;
  String path;
  GenericService<T> service;
  late DataTypeMarshall<T> dataTypeMarshall;

  GenericAPI({required this.path, required this.router, required this.service}) {
    router.get('/$path/<id>', get);
    router.get('/$path', getAll);
    router.post('/$path', save);
    router.put('/$path/<id>', update);
    router.delete('/$path/<id>', delete);
    dataTypeMarshall = DataTypeMarshall<T>();
  }

  get(Request request, String id) {
    return service.getById(int.parse(id));
  }

  getAll(Request request) {
    return service.getAll();
  }

  Future<Response> save(Request request) async {
    final parameters = await request.body.asJson;

    T entity = dataTypeMarshall.fromJson(parameters);

    try {
      service.save(entity);
    } catch (e) {
      return Response.badRequest(body: 'Erro ao cadastrar. Erro: ${e.toString()}');
    }

    return Response.ok('Cadastrado com sucesso');
  }

  Future<Response> update(Request request, String id) async {
    final parameters = await request.body.asJson;

    T? entity = service.getById(int.parse(id));

    if (entity == null) {
      return Response.notFound('registro não encontrado');
    }

    entity = dataTypeMarshall.fromJson(parameters);
    (entity as dynamic).id = int.parse(id);

    try {
      service.update(entity!);
    } catch (e) {
      return Response.badRequest(body: 'Erro ao atualizar. Erro: ${e.toString()}');
    }

    return Response.ok('Atualizado com sucesso');
  }

  Future<Response> delete(Request request, String id) async {
    T? entity = service.getById(int.parse(id));

    if (entity == null) {
      return Response.notFound('registro não encontrado');
    }

    service.delete(entity);
    return Response.ok('Deletado com sucesso');
  }
}
